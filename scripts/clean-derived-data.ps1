param (
    [Parameter(Mandatory = $true)][string]$WorktreePath
)

# Deletes the DerivedData folders Xcode made for one worktree. Each folder's info.plist records the workspace it
# belongs to, so this matches on that path rather than guessing from the folder name's hash. The worktree itself
# doesn't need to exist anymore.

$ErrorActionPreference = 'Stop'

$worktree = [System.IO.Path]::GetFullPath($WorktreePath).TrimEnd('/')

# Only ever clean up after worktrees: never the main checkout's build products.
if ($worktree -notmatch '/\.claude/worktrees/[^/]+$') {
    Write-Error "Not a worktree under .claude/worktrees: $worktree"
    exit 1
}

$derivedData = defaults read com.apple.dt.Xcode IDECustomDerivedDataLocation 2>$null
if ($LASTEXITCODE -ne 0 -or -not $derivedData) {
    $derivedData = Join-Path $HOME "Library/Developer/Xcode/DerivedData"
}

if (-not (Test-Path $derivedData)) {
    "No DerivedData folder at $derivedData" | Write-Output
    exit 0
}

$removed = 0
foreach ($folder in Get-ChildItem -Path $derivedData -Directory) {
    $infoPlist = Join-Path $folder.FullName "info.plist"
    if (-not (Test-Path $infoPlist)) { continue }

    $workspacePath = plutil -extract WorkspacePath raw $infoPlist 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $workspacePath) { continue }

    if ($workspacePath -eq $worktree -or $workspacePath.StartsWith("$worktree/")) {
        "Deleting $($folder.FullName) ($workspacePath)" | Write-Output
        Remove-Item -Recurse -Force $folder.FullName
        $removed++
    }
}

"Deleted $removed DerivedData folder(s) for $worktree" | Write-Output
