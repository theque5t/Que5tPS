function Get-CardanoTransactionAllocationsFeeStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $allocationsFeeStatus = [PSCustomObject]@()
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation
    $allocations.ForEach({
        $allocationsFeeStatus += Get-CardanoTransactionAllocationFeeStatus `
            -Transaction $Transaction `
            -Recipient $_.Recipient
    })
    return $allocationsFeeStatus
}
