function Get-CardanoTransactionAllocationFeeStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient -or
            $_ -eq $Transaction.ChangeAllocation.Recipient
        })]
        [string]$Recipient
    )
    $feeAllocationsStatus += [PSCustomObject]@{
        FeePercentage = Get-CardanoTransactionAllocationFeePercentage `
            -Transaction $Transaction `
            -Recipient $Recipient `
            -Transform String
        AllocatedFunds = $(Get-CardanoTransactionAllocationValue `
            -Transaction $Transaction `
            -Recipient $Recipient `
            -PolicyId '' `
            -Name 'lovelace').Quantity ?? 0
        AllocatedFees = Get-CardanoTransactionAllocationFee `
            -Transaction $Transaction `
            -Recipient $Recipient
        Balance = Get-CardanoTransactionAllocationFundBalance `
            -Transaction $Transaction `
            -Recipient $Recipient
        Covered = Test-CardanoTransactionAllocationFeeCovered `
            -Transaction $Transaction `
            -Recipient $Recipient
        Recipient = $Recipient
    }
    return $feeAllocationsStatus
}