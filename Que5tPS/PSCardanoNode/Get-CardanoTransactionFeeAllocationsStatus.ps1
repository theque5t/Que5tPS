function Get-CardanoTransactionFeeAllocationsStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $feeAllocationsStatus = [PSCustomObject]@()
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation
    $feeAllocations = Get-CardanoTransactionFeeAllocations -Transaction $Transaction
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
