function Assert-CardanoTransactionSignedFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    if(-not $(Test-CardanoTransactionSignedFileExists -Transaction $Transaction)){
        Write-FalseAssertionError
    }
}
