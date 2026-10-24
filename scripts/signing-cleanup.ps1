param (
    [string]$KeychainName = "highlighter-ci.keychain-db"
)

"Deleting keychain: $KeychainName" | Write-Output
security delete-keychain $KeychainName
