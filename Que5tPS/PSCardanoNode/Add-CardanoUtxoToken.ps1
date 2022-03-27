function Add-CardanoUtxoToken {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoUtxo]$Utxo,
        [Parameter(Mandatory = $true)]
        [CardanoToken]$Token,
        [bool]$UpdateState = $true
    )
    $Utxo.Value += $Token
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
