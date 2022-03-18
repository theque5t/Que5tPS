function Assert-CardanoTransactionBodyFileDoesNotExist {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionBodyFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
