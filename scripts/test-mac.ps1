$env:NSUnbufferedIO = 'YES'
$destination = "platform=macOS,variant=Mac Catalyst"

$speedArgs = @(
    "-enableCodeCoverage", "NO",
    "COMPILER_INDEX_STORE_ENABLE=NO"
)

# Build and run the tests
"Running tests…" | Write-Output
& {
    xcodebuild test `
      -workspace Highlighter.xcworkspace `
      -scheme Highlighter `
      -destination $destination `
      @speedArgs 2>&1

    $script:xcodebuildExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:xcodebuildExitCode -ne 0) {
    Write-Error "xcodebuild test failed with exit code $($script:xcodebuildExitCode)"
    exit $script:xcodebuildExitCode
}
