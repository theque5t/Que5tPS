function Add-CardanoTransactionInput {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [CardanoUtxo]$Utxo,
        [bool]$UpdateState = $true
    )
    $Transaction.Inputs += $Utxo
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
