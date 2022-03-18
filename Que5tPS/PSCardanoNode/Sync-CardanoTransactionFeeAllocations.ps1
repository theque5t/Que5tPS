function Sync-CardanoTransactionFeeAllocations {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $feeAllocations = Get-CardanoTransactionFeeAllocations -Transaction $Transaction
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation

    $feeAllocations.Where({ $_.Recipient -notin $allocations.Recipient }).ForEach({
        Remove-CardanoTransactionFeeAllocation -Transaction $Transaction `
            -Recipient $_.Recipient
    })

    Initialize-CardanoTransactionFeeAllocations -Transaction $Transaction `
        -Recipients $allocations.Where({ 
                $_.Recipient -notin $feeAllocations.Recipient 
            }).Recipient
}
