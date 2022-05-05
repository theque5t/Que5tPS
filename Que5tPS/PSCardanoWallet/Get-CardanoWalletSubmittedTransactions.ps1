function Get-CardanoWalletSubmittedTransactions {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $transactions = Get-CardanoWalletTransactions -Wallet $Wallet
    $transactions = $transactions.Where({
        $(Test-CardanoTransactionIsSubmitted -Transaction $_)
    })
    return $transactions
}
