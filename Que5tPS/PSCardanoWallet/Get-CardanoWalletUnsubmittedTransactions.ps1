function Get-CardanoWalletUnsubmittedTransactions {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $transactions = Get-CardanoWalletTransactions -Wallet $Wallet
    $transactions = $transactions.Where({
        -not $(Test-CardanoTransactionIsSubmitted -Transaction $_)
    })
    return $transactions
}
