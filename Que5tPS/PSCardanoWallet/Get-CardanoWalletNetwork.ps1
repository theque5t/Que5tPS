function Get-CardanoWalletNetwork {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.Network
}
