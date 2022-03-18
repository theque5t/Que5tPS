function Assert-CardanoTransactionBodyFileDoesNotExist {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionBodyFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
