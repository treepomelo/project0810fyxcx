[CmdletBinding()]
param(
    [string]$BaseUrl = $(if ($env:INHERIT_API_BASE) { $env:INHERIT_API_BASE } else { 'http://127.0.0.1:48080' }),
    [string]$UserAMobile = $env:INHERIT_USER_A_MOBILE,
    [string]$UserBMobile = $env:INHERIT_USER_B_MOBILE,
    [string]$UserAPassword = $env:INHERIT_USER_A_PASSWORD,
    [string]$UserBPassword = $env:INHERIT_USER_B_PASSWORD,
    [string]$AdminUsername = $(if ($env:INHERIT_ADMIN_USERNAME) { $env:INHERIT_ADMIN_USERNAME } else { 'admin' }),
    [string]$AdminPassword = $env:INHERIT_ADMIN_PASSWORD
)
$ErrorActionPreference = 'Stop'
$root = $BaseUrl.TrimEnd('/')
$app = "$root/app-api"
$admin = "$root/admin-api"
$pass = 0
$notRun = 0
function Pass([string]$name) { $script:pass++; Write-Host "[PASS] $name" }
function NotRun([string]$name, [string]$reason) { $script:notRun++; Write-Host "[NOT RUN] $name - $reason" }
function Assert-Code([string]$name, $body, [int]$expected = 0) {
    if ($null -eq $body -or [int]$body.code -ne $expected) { throw "$name expected code=$expected actual=$($body.code) msg=$($body.msg)" }
    Pass $name
}
function Get-App([string]$path, [hashtable]$headers = @{}) { Invoke-RestMethod -Uri ($app + $path) -Method Get -Headers $headers }
function Send-App([string]$method, [string]$path, $body, [hashtable]$headers = @{}) {
    $h = @{ 'Content-Type' = 'application/json' }; foreach ($k in $headers.Keys) { $h[$k] = $headers[$k] }
    $json = if ($null -eq $body) { $null } else { $body | ConvertTo-Json -Depth 10 -Compress }
    Invoke-RestMethod -Uri ($app + $path) -Method $method -Headers $h -Body $json
}
function Send-Admin([string]$method, [string]$path, $body, [hashtable]$headers) {
    $h = @{ 'Content-Type' = 'application/json' }; foreach ($k in $headers.Keys) { $h[$k] = $headers[$k] }
    $json = if ($null -eq $body) { $null } else { $body | ConvertTo-Json -Depth 10 -Compress }
    Invoke-RestMethod -Uri ($admin + $path) -Method $method -Headers $h -Body $json
}
function Login-App([string]$mobile, [string]$password, [string]$label) {
    if ([string]::IsNullOrWhiteSpace($mobile) -or [string]::IsNullOrWhiteSpace($password)) { throw "$label login requires mobile and password environment variables" }
    $r = Send-App 'POST' '/member/auth/login' @{ mobile = $mobile; password = $password }
    Assert-Code "$label login" $r
    if ([string]::IsNullOrWhiteSpace($r.data.accessToken)) { throw "$label login returned no token" }
    Write-Host "$label login userId=$($r.data.userId) token obtained: YES"
    return @{ Authorization = "Bearer $($r.data.accessToken)"; UserId = [long]$r.data.userId }
}
try {
    $page = Get-App '/inherit/inheritor/page?pageNo=1&pageSize=10'
    Assert-Code 'public inheritor page' $page
    $items = @($page.data.list)
    if ($items.Count -eq 0) { throw 'public inheritor page returned no data' }
    $id = [long]$items[0].id
    foreach ($check in @(
        @{ Name='public inheritor get'; Path="/inherit/inheritor/get?id=$id" },
        @{ Name='public inheritor works'; Path="/inherit/inheritor/works?id=$id" },
        @{ Name='public inheritor qualifications'; Path="/inherit/inheritor/qualifications?id=$id" },
        @{ Name='public inheritor projects'; Path="/inherit/inheritor/projects?id=$id" },
        @{ Name='public inheritor products'; Path="/inherit/inheritor/products?id=$id" },
        @{ Name='public inheritor services'; Path="/inherit/inheritor/services?id=$id" }
    )) { Assert-Code $check.Name (Get-App $check.Path) }
        $contactRaw = Invoke-WebRequest -Uri ($app + "/inherit/inheritor/contact?id=$id") -Method Get -SkipHttpErrorCheck
    $contactBody = $contactRaw.Content | ConvertFrom-Json
    if ([int]$contactRaw.StatusCode -ne 200 -or [int]$contactBody.code -ne 401) { throw "unauthorized contact expected HTTP 200/CommonResult.code 401 actual HTTP $($contactRaw.StatusCode)/code $($contactBody.code)" }
    Pass 'contact unauthenticated CommonResult.code=401'

    $a = $null
    if ([string]::IsNullOrWhiteSpace($UserAMobile) -or [string]::IsNullOrWhiteSpace($UserAPassword)) {
        NotRun 'authenticated User A cases' 'INHERIT_USER_A_MOBILE and INHERIT_USER_A_PASSWORD are not set'
    } else {
        $a = Login-App $UserAMobile $UserAPassword 'User A'
        try { Send-App 'DELETE' "/inherit/inheritor-follow/delete?inheritorId=$id" $null $a | Out-Null } catch { }
        Assert-Code 'follow public' (Send-App 'POST' '/inherit/inheritor-follow/create' @{ inheritorId = $id } $a)
        $follow = Get-App "/inherit/inheritor-follow/get?inheritorId=$id" $a; Assert-Code 'follow get User A' $follow
        if (-not $follow.data.isFollowed -or [int]$follow.data.followCount -lt 1) { throw 'follow state/count assertion failed' }; Pass 'follow state/count'
        $my = Get-App '/inherit/inheritor-follow/page?pageNo=1&pageSize=10' $a; Assert-Code 'follow my-page User A' $my
        if (@($my.data.list | Where-Object { [long]$_.id -eq $id }).Count -eq 0) { throw 'User A my-follow did not contain public inheritor' }; Pass 'my-follow contains public inheritor'
        Assert-Code 'unfollow public' (Send-App 'DELETE' "/inherit/inheritor-follow/delete?inheritorId=$id" $null $a)
        $afterUnfollow = Get-App "/inherit/inheritor-follow/get?inheritorId=$id" $a; Assert-Code 'follow state after unfollow' $afterUnfollow
        if ($afterUnfollow.data.isFollowed) { throw 'unfollow did not clear follow state' }; Pass 'unfollow state false'
        Assert-Code 're-follow after logical delete' (Send-App 'POST' '/inherit/inheritor-follow/create' @{ inheritorId = $id } $a)
        $dup = Send-App 'POST' '/inherit/inheritor-follow/create' @{ inheritorId = $id } $a
        if ([int]$dup.code -eq 0 -or [int]$dup.code -eq 1062) { throw 'duplicate follow was accepted or leaked SQL 1062' }; Pass 'duplicate follow rejected as business error'
        $contact = Get-App "/inherit/inheritor/contact?id=$id" $a; Assert-Code 'contact authenticated' $contact
        if ([string]::IsNullOrWhiteSpace($contact.data.phone)) { throw 'authenticated contact did not return phone' }
        if (@($contact.data.psobject.Properties.Name | Where-Object { $_ -ne 'phone' }).Count -ne 0) { throw 'contact response returned fields beyond phone' }; Pass 'contact response contains phone only'
    }

    if ($a -and (-not [string]::IsNullOrWhiteSpace($env:INHERIT_HIDDEN_ID))) {
        foreach ($hiddenIdText in ($env:INHERIT_HIDDEN_ID -split ',' | Where-Object { $_ -and $_.Trim() })) {
            $hiddenId = [long]$hiddenIdText
            $hiddenContact = Get-App "/inherit/inheritor/contact?id=$hiddenId" $a
            if ([int]$hiddenContact.code -eq 0 -or $null -ne $hiddenContact.data.phone) { throw "hidden contact was exposed id=$hiddenId" }; Pass "hidden contact rejected id=$hiddenId"
            $hiddenFollow = Send-App 'POST' '/inherit/inheritor-follow/create' @{ inheritorId = $hiddenId } $a
            if ([int]$hiddenFollow.code -eq 0) { throw "hidden follow was accepted id=$hiddenId" }; Pass "hidden follow rejected id=$hiddenId"
            $hiddenPage = Get-App '/inherit/inheritor-follow/page?pageNo=1&pageSize=10' $a; Assert-Code "hidden my-follow filter id=$hiddenId" $hiddenPage
            if (@($hiddenPage.data.list | Where-Object { [long]$_.id -eq $hiddenId }).Count -ne 0) { throw "hidden inheritor appeared in my-follow id=$hiddenId" }; Pass "hidden my-follow filtered id=$hiddenId"
        }
    } else { NotRun 'hidden contact/follow cases' 'INHERIT_HIDDEN_ID is not set or User A credentials are unavailable' }

    if ([string]::IsNullOrWhiteSpace($UserBPassword) -or [string]::IsNullOrWhiteSpace($UserBMobile)) {
        NotRun 'User B cross-account isolation' 'second member credentials are unavailable'
    } elseif ($a) {
        $b = Login-App $UserBMobile $UserBPassword 'User B'
        $bPage = Get-App '/inherit/inheritor-follow/page?pageNo=1&pageSize=10' $b; Assert-Code 'follow my-page User B' $bPage
        if (@($bPage.data.list | Where-Object { [long]$_.id -eq $id }).Count -ne 0) { throw 'User B saw User A follow' }; Pass 'follow user isolation'
    }

    if ($a) {
        $serviceInheritorId = $null; $services = $null
        foreach ($candidate in $items) {
            $candidateServices = Get-App "/inherit/inheritor/services?id=$($candidate.id)" $a
            if ([int]$candidateServices.code -eq 0 -and @($candidateServices.data).Count -gt 0) { $serviceInheritorId = [long]$candidate.id; $services = $candidateServices; break }
        }
        if ($serviceInheritorId) {
            Pass 'inheritor services authenticated'
            $service = @($services.data | Where-Object { $_.bookingEnabled -eq $true }) | Select-Object -First 1
            if (-not $service) { $service = @($services.data) | Select-Object -First 1 }
            $sid = [long]$service.serviceId; Write-Host "serviceId=$sid"
            $detail = Get-App "/heritage/service/get?id=$sid" $a; Assert-Code 'service detail authenticated' $detail
            $schedules = Get-App "/heritage/service/schedule-list?serviceId=$sid" $a; Assert-Code 'service schedules authenticated' $schedules
            $now = [DateTime]::Now
            $schedule = @($schedules.data | Where-Object { $_.available -eq $true }) | Select-Object -First 1
            if ($schedule) {
                $bookingReq = @{ serviceId=$sid; scheduleId=[long]$schedule.id; contactName='DEV_E2E_USER_A'; contactPhone=$UserAMobile; peopleCount=1; remark='INHERIT_PHASE1_E2E' }
                $booking = Send-App 'POST' '/heritage/service-booking/create' $bookingReq $a; Assert-Code 'inheritor booking create' $booking
                $bookingId = [long]$booking.data
                if ($bookingId -le 0) { throw 'booking create returned no bookingId' }; Pass 'bookingId present'
                $myBookings = Get-App '/heritage/service-booking/my-page?pageNo=1&pageSize=20' $a; Assert-Code 'my booking' $myBookings
                if (@($myBookings.data.list | Where-Object { [long]$_.bookingId -eq $bookingId }).Count -eq 0) { throw 'new booking not found in my-page' }; Pass 'new booking visible in my-page'
                $cancel = Send-App 'PUT' "/heritage/service-booking/cancel?id=$bookingId" $null $a; Assert-Code 'booking cancel' $cancel
                Pass 'booking cancelled'
                Write-Host "BOOKING_READBACK_REQUIRED id=$bookingId scheduleId=$($schedule.id) serviceId=$sid userId=$($a.UserId)"
            } else { NotRun 'inheritor booking create/cancel' 'no active future schedule with capacity' }
        } else { NotRun 'inheritor service booking linkage' 'no public inheritor has an active service relation' }
    }
    if ([string]::IsNullOrWhiteSpace($AdminPassword)) {
        NotRun 'admin relation CRUD and hidden-data E2E' 'INHERIT_ADMIN_PASSWORD is not set'
    } else {
        $login = Invoke-RestMethod -Uri ($admin + '/system/auth/login') -Method Post -Headers @{ 'Content-Type'='application/json' } -Body (@{ username=$AdminUsername; password=$AdminPassword } | ConvertTo-Json -Compress)
        Assert-Code 'admin login' $login
        $ah = @{ Authorization = "Bearer $($login.data.accessToken)" }
        $spu = Get-App '/product/spu/page?pageNo=1&pageSize=1'; Assert-Code 'active SPU source' $spu
        $service = Get-App '/heritage/product-system/item-page?code=HANDCRAFT_EXPERIENCE&pageNo=1&pageSize=1'; Assert-Code 'active service source' $service
        if (@($spu.data.list).Count -gt 0) {
            $rid = (Send-Admin 'POST' '/inherit/inheritor-product-relation/create' @{ inheritorId=$id; spuId=[long]$spu.data.list[0].id; status=1; sort=1 } $ah).data
            Pass 'product relation create'
            $dup = Send-Admin 'POST' '/inherit/inheritor-product-relation/create' @{ inheritorId=$id; spuId=[long]$spu.data.list[0].id; status=1 } $ah
            if ([int]$dup.code -eq 0) { throw 'product relation duplicate was accepted' }; Pass 'product relation duplicate rejected'
            Assert-Code 'product relation delete' (Send-Admin 'DELETE' "/inherit/inheritor-product-relation/delete?id=$rid" $null $ah)
            Assert-Code 'product relation recreate' (Send-Admin 'POST' '/inherit/inheritor-product-relation/create' @{ inheritorId=$id; spuId=[long]$spu.data.list[0].id; status=1 } $ah)
        } else { NotRun 'product relation CRUD' 'no active product_spu row' }
        if (@($service.data.list).Count -gt 0) {
            $sid=[long]$service.data.list[0].targetId
            $srid = (Send-Admin 'POST' '/inherit/inheritor-service-relation/create' @{ inheritorId=$id; serviceId=$sid; status=1; sort=1 } $ah).data
            Pass 'service relation create'
            $sdup = Send-Admin 'POST' '/inherit/inheritor-service-relation/create' @{ inheritorId=$id; serviceId=$sid; status=1 } $ah
            if ([int]$sdup.code -eq 0) { throw 'service relation duplicate was accepted' }; Pass 'service relation duplicate rejected'
            Assert-Code 'service relation delete' (Send-Admin 'DELETE' "/inherit/inheritor-service-relation/delete?id=$srid" $null $ah)
            Assert-Code 'service relation recreate' (Send-Admin 'POST' '/inherit/inheritor-service-relation/create' @{ inheritorId=$id; serviceId=$sid; status=1 } $ah)
            Assert-Code 'inheritor service detail linkage' (Get-App "/heritage/service/get?id=$sid")
            Assert-Code 'inheritor service schedule linkage' (Get-App "/heritage/service/schedule-list?serviceId=$sid")
        } else { NotRun 'service relation CRUD/linkage' 'no active heritage service item' }
    }
    Write-Host "CASE SUMMARY: $pass PASS / $notRun NOT RUN / 0 FAIL"
    Write-Host "SUITE SUMMARY: inherit-phase1-e2e completed (see case summary)"
    exit 0
} catch {
    Write-Host "[FAIL] $($_.Exception.Message)"
    Write-Host "SUMMARY: $pass PASS / $notRun NOT RUN / 1 FAIL"
    exit 1
}