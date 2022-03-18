function Get-CardanoTransactionUnallocatedFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [switch]$String
    )
    $allocatedFeePercentage = Get-CardanoTransactionAllocatedFeePercentage -Transaction $Transaction
    $unallocatedFeePercentage = 1 - $allocatedFeePercentage
    if($String){
        $unallocatedFeePercentage = $unallocatedFeePercentage.ToString('P')
    }
    return $unallocatedFeePercentage
}
