function Test-CardanoWalletTransactionNameExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $transactions = Get-CardanoWalletTransactions -Wallet $Wallet
    return $Name -in $transactions.Name
}
