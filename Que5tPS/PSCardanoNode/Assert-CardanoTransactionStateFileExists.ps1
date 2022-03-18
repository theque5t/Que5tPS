function Assert-CardanoTransactionStateFileExists {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    if(-not $(Test-CardanoTransactionStateFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
