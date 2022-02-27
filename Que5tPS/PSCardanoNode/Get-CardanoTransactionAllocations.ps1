function Get-CardanoTransactionAllocations {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.Allocations
}
