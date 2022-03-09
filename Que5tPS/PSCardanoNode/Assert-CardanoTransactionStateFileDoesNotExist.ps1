function Assert-CardanoTransactionStateFileDoesNotExist {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if($($Transaction | Test-CardanoTransactionStateFileExists)){
        Write-FalseAssertionError
    }
}
