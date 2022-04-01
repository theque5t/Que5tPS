function Assert-CardanoTransactionSignedFileDoesNotExist {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if($(Test-CardanoTransactionSignedFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
