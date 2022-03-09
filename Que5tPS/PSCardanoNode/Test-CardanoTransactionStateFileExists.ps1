function Test-CardanoTransactionStateFileExists {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    return Test-Path $Transaction.StateFile
}
