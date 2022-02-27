function Add-CardanoTransactionInput {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [CardanoUtxo]$Utxo
    )
    $Transaction.Inputs += $Utxo
}
