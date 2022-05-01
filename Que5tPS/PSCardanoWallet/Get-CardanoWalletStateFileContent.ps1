function Get-CardanoWalletStateFileContent {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $stateFileContent = $Wallet.StateFileContent
    return $stateFileContent
}
