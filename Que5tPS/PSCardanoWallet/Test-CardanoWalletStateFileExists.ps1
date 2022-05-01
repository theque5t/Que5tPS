function Test-CardanoWalletStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $stateFile = Get-CardanoWalletStateFile -Wallet $Wallet
    return Test-Path $stateFile
}
