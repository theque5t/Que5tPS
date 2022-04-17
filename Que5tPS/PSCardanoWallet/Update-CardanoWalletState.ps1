function Update-CardanoWalletState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    Export-CardanoWalletState -Wallet $Wallet
    Import-CardanoWalletState -Wallet $Wallet
}
