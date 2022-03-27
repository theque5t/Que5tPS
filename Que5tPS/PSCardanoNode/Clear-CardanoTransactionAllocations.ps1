function Clear-CardanoTransactionAllocations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [bool]$UpdateState = $true
    )
    $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
