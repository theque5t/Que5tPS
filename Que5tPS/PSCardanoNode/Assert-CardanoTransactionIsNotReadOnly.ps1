function Assert-CardanoTransactionIsNotReadOnly {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionIsReadOnly -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
