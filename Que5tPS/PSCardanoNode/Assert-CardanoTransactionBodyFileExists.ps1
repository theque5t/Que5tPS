function Assert-CardanoTransactionBodyFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if(-not $(Test-CardanoTransactionBodyFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
