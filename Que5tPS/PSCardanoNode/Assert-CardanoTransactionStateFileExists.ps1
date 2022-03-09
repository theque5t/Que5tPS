function Assert-CardanoTransactionStateFileExists {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if(-not $($Transaction | Test-CardanoTransactionStateFileExists)){
        Write-FalseAssertionError
    }
}
