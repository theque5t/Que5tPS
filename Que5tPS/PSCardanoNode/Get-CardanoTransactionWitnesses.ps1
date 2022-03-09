function Get-CardanoTransactionWitnesses {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $inputs = $Transaction | Get-CardanoTransactionInputs
    $witnesses = $inputs.ForEach({ $_.Address }) | Sort-Object | Get-Unique
    return $witnesses
}