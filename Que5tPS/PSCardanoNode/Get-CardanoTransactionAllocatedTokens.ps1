function Get-CardanoTransactionAllocatedTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
    $allocatedTokens = Merge-CardanoTokens -Tokens $allocations.Value
    return $allocatedTokens
}
