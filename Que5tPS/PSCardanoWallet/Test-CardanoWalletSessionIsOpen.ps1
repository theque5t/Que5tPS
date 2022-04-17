function Test-CardanoWalletSessionIsOpen {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $walletSessionPath = Get-CardanoWalletSessionPaths
    return $Wallet.StateFile -in $walletSessionPath
}
