function Register-CardanoWalletSession {
    [CmdletBinding()]
    param()
    New-Item -Path 'env:CARDANO_WALLET_SESSION' `
             -Value $true |
             Out-Null
}
