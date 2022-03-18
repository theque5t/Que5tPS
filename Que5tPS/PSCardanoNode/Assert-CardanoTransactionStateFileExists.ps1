function Assert-CardanoTransactionStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if(-not $(Test-CardanoTransactionStateFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
