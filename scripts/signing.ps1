param (
    [string[]]$CertificateSecrets = @(
        "APPLE_DISTRIBUTION_CERT"
    ),
    [string]$CertificatePasswordSecret = "APPLE_CERT_PASSWORD",
    [string[]]$ProfileSecrets = @(
        "APPLE_PROFILE_ACTION",
        "APPLE_PROFILE_APP",
        "APPLE_PROFILE_PHOTO",
        "APPLE_PROFILE_WIDGET"
    ),
    [string]$KeychainName = "highlighter-ci.keychain-db"
)

$ErrorActionPreference = 'Stop'

$workDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $workDir | Out-Null

function Get-DecodedSecret {
    param (
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Path
    )

    $encoded = buildkite-agent secret get $Name
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Could not read secret: $Name"
        exit 1
    }

    [System.IO.File]::WriteAllBytes($Path, [System.Convert]::FromBase64String($encoded))
}

try {
    # Create a temporary keychain for the signing certificate
    "Creating keychain: $KeychainName" | Write-Output
    $keychainPassword = [System.Guid]::NewGuid().ToString()
    security delete-keychain $KeychainName 2>$null
    security create-keychain -p $keychainPassword $KeychainName
    security set-keychain-settings -lut 21600 $KeychainName
    security unlock-keychain -p $keychainPassword $KeychainName

    # Import the signing certificates
    $certificatePassword = ""
    if ($CertificatePasswordSecret) {
        $certificatePassword = buildkite-agent secret get $CertificatePasswordSecret
    }

    foreach ($certificateSecret in $CertificateSecrets) {
        "Importing certificate: $certificateSecret" | Write-Output
        $certificatePath = Join-Path $workDir "$certificateSecret.p12"
        Get-DecodedSecret -Name $certificateSecret -Path $certificatePath
        security import $certificatePath `
          -k $KeychainName `
          -P $certificatePassword `
          -T /usr/bin/codesign `
          -T /usr/bin/productbuild `
          -T /usr/bin/security
    }
    security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k $keychainPassword $KeychainName | Out-Null

    # Add the keychain to the search list so codesign can find it
    $existingKeychains = security list-keychains -d user | ForEach-Object { $_.Trim().Trim('"') }
    security list-keychains -d user -s $KeychainName @existingKeychains

    # Install the provisioning profiles, named by UUID so Xcode can find them
    $profilesDir = Join-Path $HOME "Library/Developer/Xcode/UserData/Provisioning Profiles"
    New-Item -ItemType Directory -Force -Path $profilesDir | Out-Null

    foreach ($profileSecret in $ProfileSecrets) {
        $profilePath = Join-Path $workDir "$profileSecret.provisionprofile"
        Get-DecodedSecret -Name $profileSecret -Path $profilePath

        $profilePlist = Join-Path $workDir "$profileSecret.plist"
        security cms -D -i $profilePath -o $profilePlist
        $uuid = /usr/libexec/PlistBuddy -c "Print :UUID" $profilePlist
        $name = /usr/libexec/PlistBuddy -c "Print :Name" $profilePlist

        "Installing profile: $name ($uuid)" | Write-Output
        Copy-Item $profilePath (Join-Path $profilesDir "$uuid.provisionprofile") -Force
    }
} finally {
    Remove-Item -Recurse -Force $workDir
}
