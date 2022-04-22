function Get-CardanoWalletAddresses {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    # return $Wallet.Addresses
}
