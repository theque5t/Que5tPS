function Get-CardanoTransactionAllocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$String
    )
    $allocations = Get-CardanoTransactionAllocations `
        -Transaction $Transaction `
        -ChangeAllocation
    $allocatedFeePercentage = ConvertTo-RoundNumber `
        -Number $($allocations.FeePercentage | Measure-Object -Sum).Sum `
        -DecimalPlaces 2
    if($String){
        $allocatedFeePercentage = $allocatedFeePercentage.ToString('P')
    }
    return $allocatedFeePercentage
}
