function Test-CardanoTransactionAllocationsFeeCovered {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $allocationsFeeStatus = Get-CardanoTransactionAllocationsFeeStatus -Transaction $Transaction
    $feeAllocationsNotCovered = $allocationsFeeStatus.Where({ $_.Covered -eq $false })
    return $feeAllocationsNotCovered.Count -eq 0
}
