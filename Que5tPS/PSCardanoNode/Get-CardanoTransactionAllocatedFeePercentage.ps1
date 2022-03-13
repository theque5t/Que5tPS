function Get-CardanoTransactionAllocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [switch]$String
    )
    $feeAllocations = $Transaction | Get-CardanoTransactionFeeAllocations
    $allocatedFeePercentage = $($feeAllocations.Percentage | Measure-Object -Sum).Sum
    if($String){
        $allocatedFeePercentage = $allocatedFeePercentage.ToString('P')
    }
    return $allocatedFeePercentage
}
