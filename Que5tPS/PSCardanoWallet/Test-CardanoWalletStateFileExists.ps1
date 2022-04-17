function Test-CardanoWalletStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return Test-Path $Wallet.StateFile
}
