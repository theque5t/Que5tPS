function Get-CardanoWalletTokenDiesDirectory {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.TokenDiesDir
}
