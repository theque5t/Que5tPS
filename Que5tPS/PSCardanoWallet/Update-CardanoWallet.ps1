function Update-CardanoWallet {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    Update-CardanoWalletState -Wallet $Wallet
}
