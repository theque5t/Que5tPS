function Get-CardanoTransactionFeeAllocationsStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $feeAllocationsStatus = [PSCustomObject]@()
    $allocations = $Transaction | Get-CardanoTransactionAllocations -ChangeAllocation
    $feeAllocations = $Transaction | Get-CardanoTransactionFeeAllocations
    $feeAllocations.ForEach({
        $allocatedFunds = $allocations[$_.Recipient].Value.Where({
            $_.Name -eq 'lovelace'
        }).Quantity
        $allocatedFees = $allocatedFunds * $_.Percentage
        $balance = $allocatedFunds - $allocatedFees
        $covered = $balance -gt 0
        $feeAllocationsStatus += [PSCustomObject]@{
            Recipient = $_.Recipient
            Percentage = $_.Percentage
            AllocatedFunds = $allocatedFunds
            AllocatedFees = $allocatedFees
            Balance = $balance
            Covered = $covered
        }
    })
    return $feeAllocationsStatus
}
