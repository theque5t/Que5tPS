function Test-CardanoTransactionFeeCovered {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $feeAllocationsCovered = Test-CardanoTransactionAllocationsFeeCovered -Transaction $Transaction
    $feeBalance = Get-CardanoTransactionFeeBalance -Transaction $Transaction
    return $($feeBalance -eq 0) -and $feeAllocationsCovered
}
