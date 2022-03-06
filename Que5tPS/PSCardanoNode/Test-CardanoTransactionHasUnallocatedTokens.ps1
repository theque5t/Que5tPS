function Test-CardanoTransactionHasUnallocatedTokens {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$($Transaction | Get-CardanoTransactionUnallocatedTokens).Count
}
