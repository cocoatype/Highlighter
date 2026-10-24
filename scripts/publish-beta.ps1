param (
    [Parameter(Mandatory = $true)][ValidateSet("IOS", "MAC_OS")][string]$Platform,
    [string]$BundleID = "com.cocoatype.Highlighter",
    [string]$GroupName = "Public Testers"
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/app-store-connect.ps1"

# Use yesterday's commits as the changelog; skip publishing if there weren't any
$yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
$today = (Get-Date).ToString("yyyy-MM-dd")
$changelog = (git log --since="$yesterday 00:00:00" --until="$today 00:00:00" --pretty=format:"%s" --no-merges) -join "`n"

if (-not $changelog) {
    "No commits since $yesterday, skipping publish" | Write-Output
    exit 0
}

$keyDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
try {
    $keyPath = Save-AppStoreConnectKey -Directory $keyDirectory
    $token = New-AppStoreConnectToken -KeyPath $keyPath
} finally {
    Remove-Item -Recurse -Force $keyDirectory -ErrorAction SilentlyContinue
}

# Find the app and its most recent build for this platform
$app = (Invoke-AppStoreConnect -Token $token -Path "/v1/apps?filter[bundleId]=$BundleID").data | Select-Object -First 1
if (-not $app) {
    Write-Error "App not found: $BundleID"
    exit 1
}

$build = (Invoke-AppStoreConnect -Token $token -Path "/v1/builds?filter[app]=$($app.id)&filter[preReleaseVersion.platform]=$Platform&sort=-uploadedDate&limit=1").data | Select-Object -First 1
if (-not $build) {
    Write-Error "No $Platform builds found"
    exit 1
}

"Publishing build $($build.attributes.version) ($($build.id))" | Write-Output
if ($build.attributes.processingState -ne "VALID") {
    Write-Error "Build is not ready to publish: $($build.attributes.processingState)"
    exit 1
}

# Set the What to Test notes
"Setting changelog…" | Write-Output
$localization = (Invoke-AppStoreConnect -Token $token -Path "/v1/builds/$($build.id)/betaBuildLocalizations").data |
  Where-Object { $_.attributes.locale -eq "en-US" } |
  Select-Object -First 1

if ($localization) {
    Invoke-AppStoreConnect -Token $token -Method PATCH -Path "/v1/betaBuildLocalizations/$($localization.id)" -Body @{
        data = @{
            type = "betaBuildLocalizations"
            id = $localization.id
            attributes = @{ whatsNew = $changelog }
        }
    } | Out-Null
} else {
    Invoke-AppStoreConnect -Token $token -Method POST -Path "/v1/betaBuildLocalizations" -Body @{
        data = @{
            type = "betaBuildLocalizations"
            attributes = @{ locale = "en-US"; whatsNew = $changelog }
            relationships = @{ build = @{ data = @{ type = "builds"; id = $build.id } } }
        }
    } | Out-Null
}

# Add the build to the external testing group
"Adding build to $GroupName…" | Write-Output
$group = (Invoke-AppStoreConnect -Token $token -Path "/v1/betaGroups?filter[app]=$($app.id)&filter[name]=$([System.Uri]::EscapeDataString($GroupName))").data | Select-Object -First 1
if (-not $group) {
    Write-Error "Beta group not found: $GroupName"
    exit 1
}

Invoke-AppStoreConnect -Token $token -Method POST -Path "/v1/betaGroups/$($group.id)/relationships/builds" -Body @{
    data = @(@{ type = "builds"; id = $build.id })
} | Out-Null

# Submit for beta app review, unless it's already been submitted
$submissions = (Invoke-AppStoreConnect -Token $token -Path "/v1/betaAppReviewSubmissions?filter[build]=$($build.id)").data
if ($submissions) {
    "Build already submitted for beta review" | Write-Output
} else {
    "Submitting for beta review…" | Write-Output
    Invoke-AppStoreConnect -Token $token -Method POST -Path "/v1/betaAppReviewSubmissions" -Body @{
        data = @{
            type = "betaAppReviewSubmissions"
            relationships = @{ build = @{ data = @{ type = "builds"; id = $build.id } } }
        }
    } | Out-Null
}
