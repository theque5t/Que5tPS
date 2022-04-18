function Get-CardanoWalletName {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.Name
}
