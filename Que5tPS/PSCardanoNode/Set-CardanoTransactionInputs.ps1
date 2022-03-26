function Set-CardanoTransactionInputs {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [CardanoUtxo[]]$Utxos
    )
    $Transaction.Inputs = $Utxos
}
