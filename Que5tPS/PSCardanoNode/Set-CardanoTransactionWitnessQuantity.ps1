function Set-CardanoTransactionWitnessQuantity {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        [Int64]$Quantity
    )
    $Transaction.WitnessQuantity = $Quantity
}
