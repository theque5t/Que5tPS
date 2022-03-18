function Test-CardanoTransactionFeeCovered {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $feeAllocationsCovered = Test-CardanoTransactionFeeAllocationsCovered -Transaction $Transaction
    $feeBalance = Get-CardanoTransactionFeeBalance -Transaction $Transaction
    return $($feeBalance -eq 0) -and $feeAllocationsCovered
}
