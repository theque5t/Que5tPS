function Get-CardanoTransactionAllocatedTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $allocations = $Transaction | Get-CardanoTransactionAllocations
    $allocatedTokens = Merge-CardanoTokens -Tokens $allocations.Value
    return $allocatedTokens
}
