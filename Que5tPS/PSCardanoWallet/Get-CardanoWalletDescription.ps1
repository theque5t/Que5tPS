function Get-CardanoWalletDescription {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.Description
}
