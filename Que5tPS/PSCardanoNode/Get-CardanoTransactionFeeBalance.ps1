function Get-CardanoTransactionFeeBalance {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $minimumFee = $Transaction | Get-CardanoTransactionMinimumFee
    $allocatedFee = $Transaction | Get-CardanoTransactionAllocatedFee
    $feeBalance = $minimumFee - $allocatedFee
    return $feeBalance
}
