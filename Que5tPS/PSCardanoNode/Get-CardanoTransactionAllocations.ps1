function Get-CardanoTransactionAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [switch]$ChangeAllocation
    )
    $allocations = [CardanoTransactionAllocation[]]@()
    $allocations += $Transaction.Allocations
    if($ChangeAllocation){ 
        $allocations += $Transaction | Get-CardanoTransactionChangeAllocation
     }
    return $allocations
}
