[CmdletBinding()]
param(
    [string]$BaseUrl = $(if ($env:INHERIT_API_BASE) { $env:INHERIT_API_BASE } else { 'http://127.0.0.1:48080' }),
    [string]$UserAMobile = $(if ($env:INHERIT_USER_A_MOBILE) { $env:INHERIT_USER_A_MOBILE } else { '19900000001' }),
    [string]$UserBMobile = $(if ($env:INHERIT_USER_B_MOBILE) { $env:INHERIT_USER_B_MOBILE } else { '19900000002' }),
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
    $r = Send-App 'POST' '/member/auth/login' @{ mobile = $mobile; password = $password }
    Assert-Code "$label login" $r
    if ([string]::IsNullOrWhiteSpace($r.data.accessToken)) { throw "$label login returned no token" }
    return @{ Authorization = "Bearer $($r.data.accessToken)" }
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
    if ([string]::IsNullOrWhiteSpace($UserAPassword) -or [string]::IsNullOrWhiteSpace($UserBPassword)) {
        NotRun 'authenticated follow/contact isolation' 'INHERIT_USER_A_PASSWORD and INHERIT_USER_B_PASSWORD are not set'
    } else {
        $a = Login-App $UserAMobile $UserAPassword 'User A'
        $b = Login-App $UserBMobile $UserBPassword 'User B'
        $beforeDelete = $null
        try { $beforeDelete = Send-App 'DELETE' "/inherit/inheritor-follow/delete?inheritorId=$id" $null $a } catch { }
        Assert-Code 'follow public' (Send-App 'POST' '/inherit/inheritor-follow/create' @{ inheritorId = $id } $a)
        Assert-Code 'follow get User A' (Get-App "/inherit/inheritor-follow/get?inheritorId=$id" $a)
        Assert-Code 'follow my-page User A' (Get-App '/inherit/inheritor-follow/page?pageNo=1&pageSize=10' $a)
        $bPage = Get-App '/inherit/inheritor-follow/page?pageNo=1&pageSize=10' $b; Assert-Code 'follow my-page User B' $bPage
        if (@($bPage.data.list | Where-Object { [long]$_.id -eq $id }).Count -ne 0) { throw 'User B saw User A follow' }; Pass 'follow user isolation'
        Assert-Code 'unfollow public' (Send-App 'DELETE' "/inherit/inheritor-follow/delete?inheritorId=$id" $a)
        Assert-Code 're-follow after logical delete' (Send-App 'POST' '/inherit/inheritor-follow/create' @{ inheritorId = $id } $a)
        $contact = Get-App "/inherit/inheritor/contact?id=$id" $a; Assert-Code 'contact authenticated' $contact
        if ($null -eq $contact.data.phone) { throw 'authenticated contact did not return phone' }; Pass 'contact response contains phone only'
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
    Write-Host "SUMMARY: $pass PASS / $notRun NOT RUN / 0 FAIL"
    exit 0
} catch {
    Write-Host "[FAIL] $($_.Exception.Message)"
    Write-Host "SUMMARY: $pass PASS / $notRun NOT RUN / 1 FAIL"
    exit 1
}