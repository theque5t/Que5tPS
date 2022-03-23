function Get-CardanoTransactionChangeAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.ChangeAllocation.FeePercentage
}
