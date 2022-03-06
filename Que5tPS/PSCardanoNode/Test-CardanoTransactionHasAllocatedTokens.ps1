function Test-CardanoTransactionHasAllocatedTokens {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$($Transaction | Get-CardanoTransactionAllocatedTokens).Count
}
