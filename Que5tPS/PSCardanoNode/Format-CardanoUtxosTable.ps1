function Format-CardanoUtxosTable {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo[]]$Utxos
    )
    $utxosCopy = Clone-Object -Object $Utxos
    $utxosCopy |
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
