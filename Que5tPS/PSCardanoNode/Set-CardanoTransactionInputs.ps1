function Set-CardanoTransactionInputs {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [CardanoUtxo[]]$Utxos,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Inputs = $Utxos
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
