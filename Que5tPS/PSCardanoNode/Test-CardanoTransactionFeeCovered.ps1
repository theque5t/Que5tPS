function Test-CardanoTransactionFeeCovered {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $feeAllocationsCovered = $Transaction | Test-CardanoTransactionFeeAllocationsCovered
    $feeBalance = $Transaction | Get-CardanoTransactionFeeBalance
    return $($feeBalance -eq 0) -and $feeAllocationsCovered
}
