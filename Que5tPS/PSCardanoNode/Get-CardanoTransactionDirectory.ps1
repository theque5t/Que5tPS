function Get-CardanoTransactionDirectory {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.TransactionDir
}
