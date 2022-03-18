function Get-CardanoTransactionFeeBalance {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $minimumFee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
    $allocatedFee = Get-CardanoTransactionAllocatedFee -Transaction $Transaction
    $feeBalance = $minimumFee - $allocatedFee
    return $feeBalance
}
