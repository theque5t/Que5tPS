function Format-CardanoUtxoTableByAddressId {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo]$Utxo
    )
    $utxoCopy = Clone-Object -Object $Utxo
    $utxoCopy | 
    Select-Object * -ExpandProperty Value | 
    Format-Table $(
        'PolicyId'
        'Name'
        'Quantity'
        'Data'
    ) -GroupBy { $_.Address, $_.Id }
}
