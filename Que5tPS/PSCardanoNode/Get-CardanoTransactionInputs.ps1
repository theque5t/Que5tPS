function Get-CardanoTransactionInputs {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.Inputs
}
