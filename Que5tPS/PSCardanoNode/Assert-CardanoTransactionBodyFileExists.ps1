function Assert-CardanoTransactionBodyFileExists {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if(-not $($Transaction | Test-CardanoTransactionBodyFileExists)){
        Write-FalseAssertionError
    }
}
