function Add-CardanoTransactionInput {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [CardanoUtxo]$Utxo
    )
    $Transaction.Inputs += $Utxo
}
