function Clear-CardanoTransactionAllocations {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
}
