function Assert-CardanoTransactionBodyFileExists {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if(-not $(Test-CardanoTransactionBodyFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
