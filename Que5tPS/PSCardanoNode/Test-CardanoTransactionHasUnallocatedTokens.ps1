function Test-CardanoTransactionHasUnallocatedTokens {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionUnallocatedTokens -Transaction $Transaction).Count
}
