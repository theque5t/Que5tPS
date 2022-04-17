function Set-CardanoTransactionWitnessQuantity {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        [Int64]$Quantity,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.WitnessQuantity = $Quantity
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
