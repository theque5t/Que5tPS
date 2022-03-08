function Format-CardanoUtxoListById {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo]$Utxo
    )
    $utxoCopy = Clone-Object -Object $Utxo
    $utxoCopy | 
    Select-Object * -ExpandProperty Value | 
    Format-List $(
        'PolicyId'
        'Name'
        'Quantity'
        'Data'
    ) -GroupBy Id
}
