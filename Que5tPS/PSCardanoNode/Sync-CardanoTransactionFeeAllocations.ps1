function Sync-CardanoTransactionFeeAllocations {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $feeAllocations = $Transaction | Get-CardanoTransactionFeeAllocations
    $allocations = $Transaction | Get-CardanoTransactionAllocations -ChangeAllocation

    $feeAllocations.Where({ $_.Recipient -notin $allocations.Recipient }).ForEach({
        $Transaction | Remove-CardanoTransactionFeeAllocation `
            -Recipient $_.Recipient
    })

    $Transaction | Initialize-CardanoTransactionFeeAllocations `
        -Recipients $allocations.Where({ 
                $_.Recipient -notin $feeAllocations.Recipient 
            }).Recipient
}
