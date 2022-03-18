function Test-CardanoTransactionBodyFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return Test-Path $Transaction.BodyFile
}
