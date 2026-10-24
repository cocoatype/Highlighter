param (
    [string]$MarketingVersion,
    [string]$BuildVersion
)

$CommitCount = "git log --oneline | wc -l" | Invoke-Expression
$Branch = $Env:BUILDKITE_BRANCH

if ($Branch -and $Branch -match 'release\/(.*)') {
    $MarketingVersion = $Matches.1
} else {
    Write-Error "Missing release branch version" -ErrorAction Stop
}

Write-Output "Setting the version to $($MarketingVersion) ($($CommitCount))"

& { agvtool new-marketing-version $MarketingVersion }
& { agvtool new-version $CommitCount }
