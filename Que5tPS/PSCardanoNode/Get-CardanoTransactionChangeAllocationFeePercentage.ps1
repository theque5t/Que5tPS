function Get-CardanoTransactionChangeAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return ConvertTo-RoundNumber `
        -Number $Transaction.ChangeAllocation.FeePercentage `
        -DecimalPlaces 2
}
