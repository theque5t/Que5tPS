function Format-CardanoUtxosTableById {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxoList]$Utxos
    )
    $Utxos.Utxos | 
    Select-Object * -ExpandProperty Value | 
    Format-Table $(
        'PolicyId'
        'Name'
        'Quantity'
        'Address'
        'Data'
    ) -GroupBy Id
}
