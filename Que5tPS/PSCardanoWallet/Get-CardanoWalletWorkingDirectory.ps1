function Get-CardanoWalletWorkingDirectory {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    # return $Wallet.WorkingDir
}
