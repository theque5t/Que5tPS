function Clear-CardanoTransactionAllocations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
}
