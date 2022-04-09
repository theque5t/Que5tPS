function Clear-CardanoTransactionAllocations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
