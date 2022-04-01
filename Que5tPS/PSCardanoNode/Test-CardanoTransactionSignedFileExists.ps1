function Test-CardanoTransactionSignedFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return Test-Path $Transaction.SignedFile
}
