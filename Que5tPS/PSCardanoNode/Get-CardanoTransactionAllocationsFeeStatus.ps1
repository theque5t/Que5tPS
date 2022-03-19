function Get-CardanoTransactionAllocationsFeeStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $allocationsFeeStatus = [PSCustomObject]@()
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction
    $allocations.ForEach({
        $allocationsFeeStatus += Get-CardanoTransactionAllocationFeeStatus `
            -Transaction $Transaction
            -Recipient $_.Recipient
    })
    return $allocationsFeeStatus
}
