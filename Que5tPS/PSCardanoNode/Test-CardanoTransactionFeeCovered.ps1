function Test-CardanoTransactionFeeCovered {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $feeAllocationsStatus = $Transaction | Get-CardanoTransactionFeeAllocationsStatus
    $feeAllocationsNotCovered = $feeAllocationsStatus.Where({ $_.Covered -eq $false })
    return $feeAllocationsNotCovered.Count -eq 0
}
