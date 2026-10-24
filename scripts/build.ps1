param (
    [Parameter(Mandatory = $true)][string]$Scheme
)

$env:NSUnbufferedIO = 'YES'

$speedArgs = @(
    "EAGER_LINKING=NO"
)

"Building $Scheme…" | Write-Output
& {
    xcodebuild build `
      -workspace Highlighter.xcworkspace `
      -scheme $Scheme `
      -destination "generic/platform=iOS Simulator" `
      @speedArgs 2>&1

    $script:xcodebuildExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:xcodebuildExitCode -ne 0) {
    Write-Error "xcodebuild build failed with exit code $($script:xcodebuildExitCode)"
    exit $script:xcodebuildExitCode
}
