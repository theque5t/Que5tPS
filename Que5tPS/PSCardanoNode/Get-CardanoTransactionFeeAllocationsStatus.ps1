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
        $allocatedLovelace = $allocations[$_.Recipient].Value.Where({
            $_.Name -eq 'lovelace'
        }).Quantity
        $allocatedFunds = $allocatedLovelace ??= 0
        $allocatedFees = $allocatedFunds * $_.Percentage
        $balance = $allocatedFunds - $allocatedFees
        $covered = $balance -ge 0
        $feeAllocationsStatus += [PSCustomObject]@{
            Percentage = $_.Percentage.ToString('P')
            AllocatedFunds = $allocatedFunds
            AllocatedFees = $allocatedFees
            Balance = $balance
            Covered = $covered
            Recipient = $_.Recipient
        }
    })
    return $feeAllocationsStatus
}
