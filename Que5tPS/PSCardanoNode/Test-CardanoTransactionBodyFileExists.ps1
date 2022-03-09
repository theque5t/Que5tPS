function Test-CardanoTransactionBodyFileExists {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    return Test-Path $Transaction.BodyFile
}
