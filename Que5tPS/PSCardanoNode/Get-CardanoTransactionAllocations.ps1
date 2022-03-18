function Get-CardanoTransactionAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$ChangeAllocation
    )
    $allocations = [CardanoTransactionAllocation[]]@()
    $allocations += $Transaction.Allocations
    if($ChangeAllocation){ 
        $allocations += Get-CardanoTransactionChangeAllocation -Transaction $Transaction
     }
    return $allocations
}
