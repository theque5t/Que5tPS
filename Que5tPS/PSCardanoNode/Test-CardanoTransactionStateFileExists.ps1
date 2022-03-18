function Test-CardanoTransactionStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return Test-Path $Transaction.StateFile
}
