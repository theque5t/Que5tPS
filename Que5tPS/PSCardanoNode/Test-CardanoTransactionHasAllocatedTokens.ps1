function Test-CardanoTransactionHasAllocatedTokens {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionAllocatedTokens -Transaction $Transaction).Count
}
