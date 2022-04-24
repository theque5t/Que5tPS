function Get-CardanoWalletStateFile {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.StateFile
}
