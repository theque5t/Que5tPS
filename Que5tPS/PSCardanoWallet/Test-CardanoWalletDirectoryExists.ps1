function Test-CardanoWalletDirectoryExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $walletDir = Get-CardanoWalletDirectory -Wallet $Wallet
    return Test-Path $walletDir
}
