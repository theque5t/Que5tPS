function Assert-CardanoTransactionBodyFileDoesNotExist {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if($($Transaction | Test-CardanoTransactionBodyFileExists)){
        Write-FalseAssertionError
    }
}
