function Assert-CardanoTransactionStateFileDoesNotExist {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionStateFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
