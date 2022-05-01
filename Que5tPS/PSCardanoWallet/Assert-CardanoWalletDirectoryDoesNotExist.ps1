function Assert-CardanoWalletDirectoryDoesNotExist{
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    if($(Test-CardanoWalletDirectoryExists -Wallet $Wallet)){
        Write-FalseAssertionError
    }
}
