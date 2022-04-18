function Test-CardanoWalletSessionInSession {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $walletSessionPaths = Get-CardanoWalletSessionPaths
    return $Wallet.StateFile.FullName -in $walletSessionPaths
}
