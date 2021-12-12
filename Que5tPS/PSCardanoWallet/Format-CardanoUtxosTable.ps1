function Format-CardanoUtxosTable {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxoList]$Utxos
    )
    $Utxos.Utxos | 
    Select-Object * -ExpandProperty Value | 
    Format-Table $(
        'Id'
        'TxHash'
        'Index'
        'PolicyId'
        'Name'
        'Quantity'
        'Address'
        'Data'
    )
}
