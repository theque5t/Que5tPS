function Get-CardanoTransactionWitnessQuantity {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.WitnessQuantity
}
