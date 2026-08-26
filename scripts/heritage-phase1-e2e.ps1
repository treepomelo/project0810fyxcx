param(
    [string]$BaseUrl = $(if ($env:HERITAGE_API_BASE) { $env:HERITAGE_API_BASE } else { 'http://127.0.0.1:48080' }),
    [string]$UserAMobile = $(if ($env:HERITAGE_USER_A_MOBILE) { $env:HERITAGE_USER_A_MOBILE } else { '19900000001' }),
    [string]$UserAPassword = $env:HERITAGE_USER_A_PASSWORD,
    [string]$UserBMobile = $(if ($env:HERITAGE_USER_B_MOBILE) { $env:HERITAGE_USER_B_MOBILE } else { '19900000002' }),
    [string]$UserBPassword = $env:HERITAGE_USER_B_PASSWORD,
    [string]$AdminUsername = $(if ($env:HERITAGE_ADMIN_USERNAME) { $env:HERITAGE_ADMIN_USERNAME } else { 'heritagee2eadmin' }),
    [string]$AdminPassword = $env:HERITAGE_ADMIN_PASSWORD,
    [string]$RunId = $(if ($env:HERITAGE_E2E_RUN_ID) { $env:HERITAGE_E2E_RUN_ID } else { 'DEV_E2E_' + (Get-Date -Format 'yyyyMMddHHmmss') })
)

$ErrorActionPreference = 'Stop'
$api = ($BaseUrl.TrimEnd('/') + '/app-api')
$adminApi = ($BaseUrl.TrimEnd('/') + '/admin-api')
$pass = 0

function Pass($name) { $script:pass++; Write-Host "[PASS] $name" }
function Assert-Code($name, $response, [int]$expected = 0) {
    if ($null -eq $response -or $response.code -ne $expected) { throw "[$name] expected code=$expected, actual code=$($response.code), msg=$($response.msg)" }
    Pass $name
}
function Assert-NonZero($name, $response) {
    if ($null -eq $response -or $response.code -eq 0) { throw "[$name] expected business failure" }
    Pass "$name (code=$($response.code))"
}
function Get-Api([string]$path, [hashtable]$headers = @{}) { Invoke-RestMethod -Uri ($api + $path) -Method Get -Headers $headers }
function Send-Api([string]$method, [string]$path, $body, [hashtable]$headers = @{}) {
    $json = if ($null -eq $body) { $null } else { $body | ConvertTo-Json -Depth 10 -Compress }
    Invoke-RestMethod -Uri ($api + $path) -Method $method -Headers (@{ 'Content-Type' = 'application/json' } + $headers) -Body $json
}
function Send-Admin([string]$method, [string]$path, $body, [hashtable]$headers) {
    $json = if ($null -eq $body) { $null } else { $body | ConvertTo-Json -Depth 10 -Compress }
    Invoke-RestMethod -Uri ($adminApi + $path) -Method $method -Headers (@{ 'Content-Type' = 'application/json' } + $headers) -Body $json
}
function Login([string]$mobile, [string]$password, [string]$label) {
    if ([string]::IsNullOrWhiteSpace($password)) { throw "[$label] password is required via environment/parameter" }
    $result = Send-Api 'POST' '/member/auth/login' @{ mobile = $mobile; password = $password }
    Assert-Code "$label login" $result
    if ([string]::IsNullOrWhiteSpace($result.data.accessToken)) { throw "[$label login] accessToken is empty" }
    Write-Host "[PASS] $label token acquired (length=$($result.data.accessToken.Length))"
    return @{ Authorization = "Bearer $($result.data.accessToken)"; UserId = $result.data.userId }
}
function Schedule([long]$serviceId, [long]$scheduleId, [hashtable]$headers = @{}) {
    $r = Get-Api "/heritage/service/schedule-list?serviceId=$serviceId" $headers
    Assert-Code "schedule list service=$serviceId" $r
    @($r.data | Where-Object { [long]$_.id -eq $scheduleId } | Select-Object -First 1)
}
function Snapshot([long]$serviceId, [long]$scheduleId, [hashtable]$headers = @{}) {
    $s = Schedule $serviceId $scheduleId $headers
    if ($s.Count -eq 0) { throw "schedule $scheduleId not found" }
    return $s[0]
}
function Cleanup-Bookings([hashtable]$headers, [string]$label) {
    $page = Get-Api '/heritage/service-booking/my-page?pageNo=1&pageSize=100' $headers
    Assert-Code "$label booking cleanup read" $page
    foreach ($item in @($page.data.list)) {
        if (@(0,1) -contains [int]$item.status) { Assert-Code "$label cleanup booking $($item.bookingId)" (Send-Api 'PUT' "/heritage/service-booking/cancel?id=$($item.bookingId)" $null $headers) }
    }
}

try {
    $systems = Get-Api '/heritage/product-system/list'
    Assert-Code 'product systems' $systems
    if (@($systems.data).Count -ne 5) { throw "expected five systems, actual=$(@($systems.data).Count)" }
    $expected = @{
        CULTURAL_CREATIVE = 'PRODUCT'; HERITAGE_FOOD = 'PRODUCT'; HANDCRAFT_EXPERIENCE = 'SERVICE'; WELLNESS_COMPANION = 'SERVICE'; FOLK_PERFORMANCE = 'SERVICE'
    }
    foreach ($code in $expected.Keys) {
        $items = Get-Api "/heritage/product-system/item-page?code=$code&pageNo=1&pageSize=10"
        Assert-Code "$code item page" $items
        $item = @($items.data.list | Select-Object -First 1)
        if ($item.Count -eq 0 -or $item[0].targetType -ne $expected[$code]) { throw "$code targetType mismatch" }
        if ([string]::IsNullOrWhiteSpace([string]$item[0].targetId) -or [string]::IsNullOrWhiteSpace([string]$item[0].title)) { throw "$code item is incomplete" }
        Pass "$code -> $($expected[$code])"
        if ($expected[$code] -eq 'PRODUCT') {
            $detail = Get-Api "/product/spu/get-detail?id=$($item[0].targetId)"
            Assert-Code "$code product detail" $detail
        } else {
            $service = Get-Api "/heritage/service/get?id=$($item[0].targetId)"
            Assert-Code "$code service detail" $service
            $schedules = Get-Api "/heritage/service/schedule-list?serviceId=$($item[0].targetId)"
            Assert-Code "$code schedule" $schedules
        }
    }

    $handcraftItems = Get-Api '/heritage/product-system/item-page?code=HANDCRAFT_EXPERIENCE&pageNo=1&pageSize=10'
    $serviceItem = @($handcraftItems.data.list | Select-Object -First 1)[0]
    $allSchedules = Get-Api "/heritage/service/schedule-list?serviceId=$($serviceItem.targetId)"
    Assert-Code 'handcraft schedule source' $allSchedules
    $finite = @($allSchedules.data | Where-Object { $_.available -and $_.remaining -ne $null } | Select-Object -First 1)[0]
    $unlimited = @($allSchedules.data | Where-Object { $_.available -and $_.remaining -eq $null } | Select-Object -First 1)[0]
    if ($null -eq $finite -or $null -eq $unlimited) { throw 'demo finite/unlimited schedules are required' }

    $a = Login $UserAMobile $UserAPassword 'User A'
    $b = Login $UserBMobile $UserBPassword 'User B'
    $headersA = @{ Authorization = $a.Authorization }
    $headersB = @{ Authorization = $b.Authorization }
    Cleanup-Bookings $headersA 'User A'
    Cleanup-Bookings $headersB 'User B'

    if ([string]::IsNullOrWhiteSpace($AdminPassword)) { throw 'Admin password is required via HERITAGE_ADMIN_PASSWORD' }
    $adminLogin = Send-Api 'POST' '/member/auth/login' @{ mobile = ''; password = '' }
    $adminLogin = Invoke-RestMethod -Uri ($adminApi + '/system/auth/login') -Method Post -Headers @{ 'Content-Type' = 'application/json' } -Body (@{ username = $AdminUsername; password = $AdminPassword } | ConvertTo-Json)
    Assert-Code 'Admin login' $adminLogin
    $adminHeaders = @{ Authorization = "Bearer $($adminLogin.data.accessToken)" }

    $body = @{ serviceId = [long]$serviceItem.targetId; scheduleId = [long]$finite.id; contactName = 'E2E A'; contactPhone = $UserAMobile; peopleCount = 2; remark = "$RunId booking" }
    $before = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    $created = Send-Api 'POST' '/heritage/service-booking/create' $body $headersA
    Assert-Code 'PENDING create' $created
    $bookingId = [long]$created.data
    $afterCreate = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    if ($afterCreate -ne $before + 2) { throw "create capacity expected $($before + 2), actual $afterCreate" }
    Pass 'create capacity increased by peopleCount'

    $duplicate = Send-Api 'POST' '/heritage/service-booking/create' $body $headersA; Assert-NonZero 'duplicate blocked' $duplicate
    $myA = Get-Api '/heritage/service-booking/my-page?pageNo=1&pageSize=100' $headersA; Assert-Code 'User A my-page' $myA
    $myB = Get-Api '/heritage/service-booking/my-page?pageNo=1&pageSize=100' $headersB; Assert-Code 'User B my-page isolation' $myB
    if (@($myB.data.list).bookingId -contains $bookingId) { throw 'User B saw User A booking' }; Pass 'User B cannot see User A booking'

    $wrongOwner = Send-Api 'PUT' "/heritage/service-booking/cancel?id=$bookingId" $null $headersB; Assert-NonZero 'User B cancel A blocked' $wrongOwner
    $enumNext = Send-Api 'PUT' "/heritage/service-booking/cancel?id=$($bookingId + 1)" $null $headersB; Assert-NonZero 'booking id + 1 protected' $enumNext
    $enumMissing = Send-Api 'PUT' "/heritage/service-booking/cancel?id=999999999" $null $headersB; Assert-NonZero 'missing booking id protected' $enumMissing
    $afterWrongOwner = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    if ($afterWrongOwner -ne $afterCreate) { throw 'wrong owner changed capacity' }; Pass 'wrong owner leaves capacity unchanged'

    $confirm = Send-Admin 'PUT' "/heritage/booking/$bookingId/status?status=1" $null $adminHeaders; Assert-Code 'PENDING -> CONFIRMED' $confirm
    $afterConfirm = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    if ($afterConfirm -ne $afterCreate) { throw 'confirm changed capacity' }; Pass 'confirm capacity unchanged'
    $complete = Send-Admin 'PUT' "/heritage/booking/$bookingId/status?status=4" $null $adminHeaders; Assert-Code 'CONFIRMED -> COMPLETED' $complete
    $afterComplete = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    if ($afterComplete -ne $afterConfirm) { throw 'complete changed capacity' }; Pass 'complete capacity unchanged'

    $rebook = Send-Api 'POST' '/heritage/service-booking/create' $body $headersA; Assert-Code 'rebook after completed' $rebook
    $rebookId = [long]$rebook.data
    $cancel = Send-Api 'PUT' "/heritage/service-booking/cancel?id=$rebookId" $null $headersA; Assert-Code 'cancel pending' $cancel
    $afterCancel = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    if ($afterCancel -ne $afterComplete) { throw 'cancel did not restore capacity' }; Pass 'cancel capacity restored'
    $doubleCancel = Send-Api 'PUT' "/heritage/service-booking/cancel?id=$rebookId" $null $headersA; Assert-NonZero 'double cancel blocked' $doubleCancel

    $rejectBody = @{ serviceId = [long]$serviceItem.targetId; scheduleId = [long]$finite.id; contactName = 'E2E A'; contactPhone = $UserAMobile; peopleCount = 2; remark = "$RunId reject" }
    $rejectBefore = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    $rejectCreated = Send-Api 'POST' '/heritage/service-booking/create' $rejectBody $headersA; Assert-Code 'reject create' $rejectCreated
    $rejectId = [long]$rejectCreated.data
    $reject = Send-Admin 'PUT' "/heritage/booking/$rejectId/status?status=3" $null $adminHeaders; Assert-Code 'PENDING -> REJECTED' $reject
    $rejectAfter = [int](Snapshot $serviceItem.targetId $finite.id).bookedCount
    if ($rejectAfter -ne $rejectBefore) { throw 'reject did not restore capacity' }; Pass 'reject capacity restored'
    $doubleReject = Send-Admin 'PUT' "/heritage/booking/$rejectId/status?status=3" $null $adminHeaders; Assert-NonZero 'double reject blocked' $doubleReject

    $invalidBodies = @(
        @{ peopleCount = 0; label = 'peopleCount=0' }, @{ peopleCount = -1; label = 'peopleCount=-1' }, @{ peopleCount = 21; label = 'peopleCount=21' },
        @{ peopleCount = 1; contactName = ''; label = 'empty contactName' }, @{ peopleCount = 1; contactPhone = '123'; label = 'invalid contactPhone' }
    )
    foreach ($invalid in $invalidBodies) {
        $invalidBody = @{ serviceId = [long]$serviceItem.targetId; scheduleId = [long]$finite.id; contactName = $(if ($null -ne $invalid.contactName) { $invalid.contactName } else { 'E2E A' }); contactPhone = $(if ($null -ne $invalid.contactPhone) { $invalid.contactPhone } else { $UserAMobile }); peopleCount = $invalid.peopleCount; remark = "$RunId invalid" }
        Assert-NonZero $invalid.label (Send-Api 'POST' '/heritage/service-booking/create' $invalidBody $headersA)
    }

    $unlimitedBodyA = @{ serviceId = [long]$serviceItem.targetId; scheduleId = [long]$unlimited.id; contactName = 'E2E A'; contactPhone = $UserAMobile; peopleCount = 1; remark = "$RunId unlimited A" }
    $unlimitedBodyB = @{ serviceId = [long]$serviceItem.targetId; scheduleId = [long]$unlimited.id; contactName = 'E2E B'; contactPhone = $UserBMobile; peopleCount = 1; remark = "$RunId unlimited B" }
    $unlimitedA = Send-Api 'POST' '/heritage/service-booking/create' $unlimitedBodyA $headersA; Assert-Code 'unlimited capacity A' $unlimitedA
    $unlimitedB = Send-Api 'POST' '/heritage/service-booking/create' $unlimitedBodyB $headersB; Assert-Code 'unlimited capacity B' $unlimitedB
    $unlimitedSnapshot = Snapshot $serviceItem.targetId $unlimited.id
    if ($unlimitedSnapshot.remaining -ne $null -or -not $unlimitedSnapshot.available) { throw 'unlimited schedule DTO is incorrect' }; Pass 'unlimited capacity DTO'
    Assert-Code 'unlimited cleanup A' (Send-Api 'PUT' "/heritage/service-booking/cancel?id=$($unlimitedA.data)" $null $headersA)
    Assert-Code 'unlimited cleanup B' (Send-Api 'PUT' "/heritage/service-booking/cancel?id=$($unlimitedB.data)" $null $headersB)

    $coopBody = @{ companyName = "$RunId company"; contactName = 'E2E A'; contactPhone = $UserAMobile; cooperationType = 'CULTURAL_TOURISM'; requirement = "$RunId cooperation" }
    $coop = Send-Api 'POST' '/heritage/cooperation/application/create' $coopBody $headersA; Assert-Code 'cooperation create pending' $coop
    $coopPage = Get-Api '/heritage/cooperation/application/my-page?pageNo=1&pageSize=100' $headersA; Assert-Code 'cooperation read-back' $coopPage
    $createdCoop = @($coopPage.data.list | Where-Object { $_.id -eq [long]$coop.data })[0]
    if ($null -eq $createdCoop -or [int]$createdCoop.status -ne 0 -or $null -ne $createdCoop.processedTime) { throw 'cooperation was not initially pending/unprocessed' }
    Pass 'cooperation initial PENDING with null processedTime'
    $coopB = Get-Api '/heritage/cooperation/application/my-page?pageNo=1&pageSize=100' $headersB; Assert-Code 'cooperation isolation' $coopB
    if (@($coopB.data.list).id -contains [long]$coop.data) { throw 'User B saw User A cooperation' }; Pass 'User B cooperation isolation'
    $coopUpdate = Send-Admin 'PUT' "/heritage/cooperation/$($coop.data)/status?status=1" $null $adminHeaders; Assert-Code 'cooperation admin update' $coopUpdate
    $invalidCoop = Send-Api 'POST' '/heritage/cooperation/application/create' @{ companyName = ''; contactName = ''; contactPhone = '1'; cooperationType = 'INVALID'; requirement = '' } $headersA; Assert-NonZero 'cooperation validation' $invalidCoop

    Cleanup-Bookings $headersA 'User A final'
    Cleanup-Bookings $headersB 'User B final'
    Write-Host "RUN_ID: $RunId"
    Write-Host "SUMMARY: $pass PASS / 0 FAIL"
    exit 0
} catch {
    Write-Host "[FAIL] $($_.Exception.Message)"
    Write-Host "RUN_ID: $RunId"
    Write-Host "SUMMARY: $pass PASS / 1 FAIL"
    exit 1
}