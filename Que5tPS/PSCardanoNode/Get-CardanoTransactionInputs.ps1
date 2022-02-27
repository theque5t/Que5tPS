function Get-CardanoTransactionInputs {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.Inputs
}
