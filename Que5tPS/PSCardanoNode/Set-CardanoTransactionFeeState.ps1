function Set-CardanoTransactionFeeState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        [Int64]$Fee,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Fee = $Fee
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
