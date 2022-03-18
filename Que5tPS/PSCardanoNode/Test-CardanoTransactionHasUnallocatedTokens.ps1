function Test-CardanoTransactionHasUnallocatedTokens {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionUnallocatedTokens -Transaction $Transaction).Count
}
