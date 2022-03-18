function Get-CardanoTransactionWitnesses {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $inputs = Get-CardanoTransactionInputs -Transaction $Transaction
    $witnesses = $inputs.ForEach({ $_.Address }) | Sort-Object | Get-Unique
    return $witnesses
}
