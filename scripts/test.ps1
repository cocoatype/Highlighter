$env:NSUnbufferedIO = 'YES'
$runtime = "com.apple.CoreSimulator.SimRuntime.iOS-27-0"
$deviceType = "com.apple.CoreSimulator.SimDeviceType.iPhone-18-Pro"

$speedArgs = @(
    "-enableCodeCoverage", "NO",
    "COMPILER_INDEX_STORE_ENABLE=NO"
)

# Find all devices that match the runtime
"Looking for runtime: $runtime" | Write-Output
$sims = "xcrun simctl list --json" | Invoke-Expression | ConvertFrom-Json
$runtimeDevices = $sims.devices."$runtime"

if (-not $runtimeDevices) {
    "Runtime not found: $runtime" | Write-Error
    exit 1
}

# Find the specific device that matches the device type
"Looking for device: $deviceType" | Write-Output
$targetDevice = $runtimeDevices | Where-Object { $_.deviceTypeIdentifier -eq $deviceType } | Select-Object -First 1
if (-not $targetDevice) {
    "Device not found: $deviceType" | Write-Error
    exit 1
}

"Using device with ID: $($targetDevice.udid)" | Write-Output

# Start simulator boot in background while compilation happens
"Booting simulator in background…" | Write-Output
Start-Process -FilePath "xcrun" -ArgumentList "simctl", "boot", $targetDevice.udid -NoNewWindow

# Build for testing
"Building for testing…" | Write-Output
& {
    xcodebuild build-for-testing `
      -workspace Highlighter.xcworkspace `
      -scheme Highlighter `
      -destination "id=$($targetDevice.udid)" `
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
      Where-Object { $_.udid -eq $targetDevice.udid } |
      Select-Object -ExpandPropery state

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
      -destination "id=$($targetDevice.udid)" `
      @speedArgs 2>&1

    $script:xcodebuildExitCode = $LASTEXITCODE
} | xcbeautify --quiet --is-ci

if ($script:xcodebuildExitCode -ne 0) {
    Write-Error "xcodebuild test failed with exit code $($script:xcodebuildExitCode)"
    exit $script:xcodebuildExitCode
}
