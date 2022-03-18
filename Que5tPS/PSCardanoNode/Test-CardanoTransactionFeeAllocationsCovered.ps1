function Test-CardanoTransactionFeeAllocationsCovered {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $feeAllocationsStatus = Get-CardanoTransactionFeeAllocationsStatus -Transaction $Transaction
    $feeAllocationsNotCovered = $feeAllocationsStatus.Where({ $_.Covered -eq $false })
    return $feeAllocationsNotCovered.Count -eq 0
}
