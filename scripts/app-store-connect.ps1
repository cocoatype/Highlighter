# Shared helpers for talking to App Store Connect. Dot-source this file.

$AppStoreConnectKeyID = "7868Z6FHXW"
$AppStoreConnectIssuerID = "69a6de72-7555-47e3-e053-5b8c7c11a4d1"
$AppStoreConnectKeySecret = "APPLE_ASC_API_KEY"

# Decodes the API key secret into $Directory, named the way xcodebuild expects
function Save-AppStoreConnectKey {
    param (
        [Parameter(Mandatory = $true)][string]$Directory
    )

    $encoded = buildkite-agent secret get $AppStoreConnectKeySecret
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Could not read secret: $AppStoreConnectKeySecret"
        exit 1
    }

    New-Item -ItemType Directory -Force -Path $Directory | Out-Null
    $keyPath = Join-Path $Directory "AuthKey_$AppStoreConnectKeyID.p8"
    [System.IO.File]::WriteAllBytes($keyPath, [System.Convert]::FromBase64String($encoded))
    return $keyPath
}

function ConvertTo-Base64Url {
    param (
        [Parameter(Mandatory = $true)][byte[]]$Bytes
    )

    return [System.Convert]::ToBase64String($Bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')
}

# Creates a signed JWT for the App Store Connect API, valid for 20 minutes
function New-AppStoreConnectToken {
    param (
        [Parameter(Mandatory = $true)][string]$KeyPath
    )

    $now = [System.DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $header = @{ alg = "ES256"; kid = $AppStoreConnectKeyID; typ = "JWT" } | ConvertTo-Json -Compress
    $payload = @{
        iss = $AppStoreConnectIssuerID
        iat = $now
        exp = $now + 1200
        aud = "appstoreconnect-v1"
    } | ConvertTo-Json -Compress

    $unsigned = "$(ConvertTo-Base64Url ([System.Text.Encoding]::UTF8.GetBytes($header))).$(ConvertTo-Base64Url ([System.Text.Encoding]::UTF8.GetBytes($payload)))"

    $key = [System.Security.Cryptography.ECDsa]::Create()
    try {
        $key.ImportFromPem((Get-Content -Raw $KeyPath))
        $signature = $key.SignData(
            [System.Text.Encoding]::UTF8.GetBytes($unsigned),
            [System.Security.Cryptography.HashAlgorithmName]::SHA256)
    } finally {
        $key.Dispose()
    }

    return "$unsigned.$(ConvertTo-Base64Url $signature)"
}

function Invoke-AppStoreConnect {
    param (
        [Parameter(Mandatory = $true)][string]$Token,
        [Parameter(Mandatory = $true)][string]$Path,
        [string]$Method = "GET",
        [object]$Body
    )

    $request = @{
        Method = $Method
        Uri = "https://api.appstoreconnect.apple.com$Path"
        Headers = @{ Authorization = "Bearer $Token" }
        ContentType = "application/json"
    }

    if ($Body) {
        $request.Body = $Body | ConvertTo-Json -Depth 10 -Compress
    }

    return Invoke-RestMethod @request
}
