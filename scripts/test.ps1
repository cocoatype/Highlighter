$env:NSUnbufferedIO = 'YES'
$runtime = "com.apple.CoreSimulator.SimRuntime.iOS-27-0"
$deviceType = "com.apple.CoreSimulator.SimDeviceType.iPhone-18-Pro"

$speedArgs = @(
    "-enableCodeCoverage", "NO",
    "-collect-test-diagnostics", "never",
    "COMPILER_INDEX_STORE_ENABLE=NO"
)

# Create a simulator just for this run, so runs in parallel (other worktrees, other agents, other CI jobs) never
# share or reboot each other's device. It's deleted when the script ends, pass or fail.
$simulatorName = "Highlighter Tests $([guid]::NewGuid().ToString('N').Substring(0, 8))"
"Creating simulator: $simulatorName ($deviceType, $runtime)" | Write-Output
$udid = xcrun simctl create $simulatorName $deviceType $runtime
if ($LASTEXITCODE -ne 0 -or -not $udid) {
    "Could not create a simulator; is the runtime installed? $runtime" | Write-Error
    exit 1
}
$udid = $udid.Trim()

try {
    "Using device with ID: $udid" | Write-Output

    # Start simulator boot in background while compilation happens
    "Booting simulator in background…" | Write-Output
    Start-Process -FilePath "xcrun" -ArgumentList "simctl", "boot", $udid -NoNewWindow

    # Build for testing
    "Building for testing…" | Write-Output
    & {
        xcodebuild build-for-testing `
          -workspace Highlighter.xcworkspace `
          -scheme Highlighter `
          -destination "id=$udid" `
          @speedArgs 2>&1

        $script:xcodebuildExitCode = $LASTEXITCODE
    } | xcbeautify --quiet --is-ci

    if ($script:xcodebuildExitCode -ne 0) {
        Write-Error "xcodebuild build-for-testing failed with exit code $($script:xcodebuildExitCode)"
        exit $script:xcodebuildExitCode
    }

    # Wait for simulator to finish booting
    "Waiting for simulator to boot…" | Write-Output
    $timeout = 120
    $elapsed = 0
    while ($elapsed -lt $timeout) {
        $state = (xcrun simctl list devices --json | ConvertFrom-Json).devices."$runtime" |
          Where-Object { $_.udid -eq $udid } |
          Select-Object -ExpandProperty state

        if ($state -eq "Booted") {
            "Simulator booted successfully" | Write-Output
            break
        }

        Start-Sleep -Seconds 2
        $elapsed += 2
    }

    if ($elapsed -ge $timeout) {
        Write-Error "Simulator failed to boot within $timeout seconds"
        exit 1
    }

    # Run the tests
    "Running tests…" | Write-Output
    & {
        xcodebuild test-without-building `
          -workspace Highlighter.xcworkspace `
          -scheme Highlighter `
          -destination "id=$udid" `
          @speedArgs 2>&1

        $script:xcodebuildExitCode = $LASTEXITCODE
    } | xcbeautify --quiet --is-ci

    if ($script:xcodebuildExitCode -ne 0) {
        Write-Error "xcodebuild test failed with exit code $($script:xcodebuildExitCode)"
        exit $script:xcodebuildExitCode
    }
} finally {
    "Deleting simulator $udid…" | Write-Output
    xcrun simctl shutdown $udid 2>&1 | Out-Null
    xcrun simctl delete $udid
}
