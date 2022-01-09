function Format-CardanoUtxoListById {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo]$Utxo
    )
    $Utxo | 
    Select-Object * -ExpandProperty Value | 
    Format-List $(
        'PolicyId'
        'Name'
        'Quantity'
        'Data'
    ) -GroupBy Id
}
