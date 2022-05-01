function Get-CardanoWalletCurrentTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $transactions = Get-CardanoWalletTransactions `
        -Wallet $Wallet
    $currentTransaction = $transactions.Where({
        -not ($_ | Test-CardanoTransactionIsReadOnly)
    })
    return $currentTransaction
}
