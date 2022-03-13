function Get-CardanoTransactionUnallocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [switch]$String
    )
    $allocatedFeePercentage = $Transaction | Get-CardanoTransactionAllocatedFeePercentage
    $unallocatedFeePercentage = 1 - $allocatedFeePercentage
    if($String){
        $unallocatedFeePercentage = $unallocatedFeePercentage.ToString('P')
    }
    return $unallocatedFeePercentage
}
