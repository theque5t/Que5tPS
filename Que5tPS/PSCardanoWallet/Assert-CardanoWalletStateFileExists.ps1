function Assert-CardanoWalletStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    if(-not $(Test-CardanoWalletStateFileExists -Wallet $Wallet)){
        Write-FalseAssertionError
    }
}
