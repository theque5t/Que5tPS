function Assert-CardanoTransactionStateFileDoesNotExist {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionStateFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
