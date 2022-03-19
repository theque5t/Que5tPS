function Get-CardanoTransactionAllocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$String
    )
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
    $allocatedFeePercentage = $($allocations.FeePercentage | Measure-Object -Sum).Sum
    if($String){
        $allocatedFeePercentage = $allocatedFeePercentage.ToString('P')
    }
    return $allocatedFeePercentage
}
