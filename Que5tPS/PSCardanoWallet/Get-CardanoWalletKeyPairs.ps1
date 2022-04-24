function Get-CardanoWalletKeyPairs {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.KeyPairs
}
