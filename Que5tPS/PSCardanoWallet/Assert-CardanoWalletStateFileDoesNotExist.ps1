function Assert-CardanoWalletStateFileDoesNotExist {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    if($(Test-CardanoWalletStateFileExists -Wallet $Wallet)){
        Write-FalseAssertionError
    }
}
