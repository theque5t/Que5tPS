function Assert-CardanoTransactionDirectoryDoesNotExist {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionDirectoryExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
