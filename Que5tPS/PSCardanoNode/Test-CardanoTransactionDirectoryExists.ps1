function Test-CardanoTransactionDirectoryExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $transactionDir = Get-CardanoTransactionDirectory -Transaction $Transaction
    return Test-Path $transactionDir
}
