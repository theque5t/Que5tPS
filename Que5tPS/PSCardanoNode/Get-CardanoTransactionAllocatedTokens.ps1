function Get-CardanoTransactionAllocatedTokens {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $allocations = $Transaction | Get-CardanoTransactionAllocations
    $allocatedTokens = Merge-CardanoTokens $allocations.Value
    return $allocatedTokens
}
