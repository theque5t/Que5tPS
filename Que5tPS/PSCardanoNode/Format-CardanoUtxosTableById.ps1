function Format-CardanoUtxosTableById {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo[]]$Utxos
    )
    $utxosCopy = Clone-Object -Object $Utxos
    $utxosCopy |
    Select-Object * -ExpandProperty Value | 
    Format-Table $(
        'PolicyId'
        'Name'
        'Quantity'
        'Address'
        'Data'
    ) -GroupBy Id
}
