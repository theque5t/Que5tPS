function Test-CardanoWalletHasTransactions {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $transactions = Get-CardanoWalletTransactions -Wallet $Wallet
    return [bool]$transactions.Count
}
