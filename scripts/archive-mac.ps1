param (
    [Parameter(Mandatory = $true)][string]$ArchivePath,
    [Parameter(Mandatory = $true)][string]$ExportPath,
    [string]$Scheme = "Highlighter"
)

$env:NSUnbufferedIO = 'YES'

& {
    xcodebuild archive `
      -workspace Highlighter.xcworkspace `
      -scheme $Scheme `
      -destination "generic/platform=macOS,variant=Mac Catalyst" `
      -archivePath $ArchivePath 2>&1

    $script:xcodebuildExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:xcodebuildExitCode -ne 0) {
    Write-Error "xcodebuild archive failed with exit code $($script:xcodebuildExitCode)"
    exit $script:xcodebuildExitCode
}

& {
    xcodebuild -exportArchive `
      -exportOptionsPlist "./scripts/export-mac.plist" `
      -archivePath $ArchivePath `
      -exportPath $ExportPath 2>&1

    $script:exportExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:exportExitCode -ne 0) {
    Write-Error "xcodebuild -exportArchive failed with exit code $($script:exportExitCode)"
    exit $script:exportExitCode
}
