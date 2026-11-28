param (
    [Parameter(Mandatory = $true)][string]$ArchivePath,
    [Parameter(Mandatory = $true)][string]$ExportPath,
    [string]$Scheme,
    # Archive the native AppKit app instead of the Catalyst app
    [switch]$Native
)

if ($Native) {
    if (-not $Scheme) { $Scheme = "HighlighterMac" }
    $destination = "generic/platform=macOS"
    $exportOptionsPlist = "./scripts/export-mac-native.plist"
} else {
    if (-not $Scheme) { $Scheme = "Highlighter" }
    $destination = "generic/platform=macOS,variant=Mac Catalyst"
    $exportOptionsPlist = "./scripts/export-mac.plist"
}

$env:NSUnbufferedIO = 'YES'
. "$PSScriptRoot/app-store-connect.ps1"

& {
    xcodebuild archive `
      -workspace Highlighter.xcworkspace `
      -scheme $Scheme `
      -destination $destination `
      -archivePath $ArchivePath 2>&1

    $script:xcodebuildExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:xcodebuildExitCode -ne 0) {
    Write-Error "xcodebuild archive failed with exit code $($script:xcodebuildExitCode)"
    exit $script:xcodebuildExitCode
}

# Export and upload to App Store Connect
$keyDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
$keyPath = Save-AppStoreConnectKey -Directory $keyDirectory

& {
    xcodebuild -exportArchive `
      -exportOptionsPlist $exportOptionsPlist `
      -archivePath $ArchivePath `
      -exportPath $ExportPath `
      -authenticationKeyPath $keyPath `
      -authenticationKeyID $AppStoreConnectKeyID `
      -authenticationKeyIssuerID $AppStoreConnectIssuerID 2>&1

    $script:exportExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

Remove-Item -Recurse -Force $keyDirectory

if ($script:exportExitCode -ne 0) {
    Write-Error "xcodebuild -exportArchive failed with exit code $($script:exportExitCode)"
    exit $script:exportExitCode
}
