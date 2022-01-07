function Format-CardanoUtxoTableById {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo]$Utxo
    )
    $Utxo | 
    Select-Object * -ExpandProperty Value | 
    Format-Table $(
        'PolicyId'
        'Name'
        'Quantity'
        'Data'
    ) -GroupBy Id
}
