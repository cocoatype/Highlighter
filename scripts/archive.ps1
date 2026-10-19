param (
    [string]$ArchivePath,
    [string]$ExportPath,
    [string]$Scheme = "Highlighter"
)

& {
    xcodebuild archive `
      -workspace Highlighter.xcworkspace `
      -scheme $Scheme `
      -destination "generic/platform=iOS" `
      @speedArgs 2>&1

    $script:xcodebuildExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:xcodebuildExitCode -ne 0) {
    Write-Error "xcodebuild archive failed with exit code $($script:xcodebuildExitCode)"
    exit $script:xcodebuildExitCode
}

& {
    xcodebuild -exportArchive `
      -exportOptionsPlist "./scripts/export.plist" `
      -archivePath $ArchivePath `
      -exportPath $ExportPath 2>&1

    $script:exportExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:exportExitCode -ne 0) {
    Write-Error "xcodebuild archive failed with exit code $($script:exportExitCode)"
    exit $script:exportExitCode
}
