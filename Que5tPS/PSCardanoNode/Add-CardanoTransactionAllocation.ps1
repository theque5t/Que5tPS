function Add-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [CardanoTransactionAllocation]$Allocation
    )
    $Transaction.Allocations += $Allocation
}
