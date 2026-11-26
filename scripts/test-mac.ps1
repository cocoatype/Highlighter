$env:NSUnbufferedIO = 'YES'

$speedArgs = @(
    "-enableCodeCoverage", "NO",
    "COMPILER_INDEX_STORE_ENABLE=NO"
)

# Each run is a scheme and a destination. The Catalyst run tests everything in the Highlighter test plan. The native
# run tests the modules whose test targets declare `.mac` (see `nativeMacTestTargets` in Project.swift).
$runs = @(
    @{ Name = "Mac Catalyst"; Scheme = "Highlighter"; Destination = "platform=macOS,variant=Mac Catalyst" },
    @{ Name = "native macOS"; Scheme = "NativeMacTests"; Destination = "platform=macOS" }
)

# Run every variant even if an earlier one fails, so one run reports every failure, then fail if any did.
$failures = @()
foreach ($run in $runs) {
    "Running $($run.Name) tests…" | Write-Output
    & {
        xcodebuild test `
          -workspace Highlighter.xcworkspace `
          -scheme $run.Scheme `
          -destination $run.Destination `
          @speedArgs 2>&1

        $script:xcodebuildExitCode = $LASTEXITCODE
    } | xcbeautify --quiet --is-ci

    if ($script:xcodebuildExitCode -ne 0) {
        "$($run.Name) tests failed with exit code $($script:xcodebuildExitCode)" | Write-Output
        $failures += $run.Name
    }
}

if ($failures.Count -gt 0) {
    Write-Error "xcodebuild test failed for: $($failures -join ', ')"
    exit 1
}
