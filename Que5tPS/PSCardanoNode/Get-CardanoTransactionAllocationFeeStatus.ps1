function Get-CardanoTransactionAllocationFeeStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient
    )
    $feeAllocationsStatus += [PSCustomObject]@{
        Percentage = Get-CardanoTransactionAllocationFeePercentage `
            -Transaction $Transaction `
            -Recipient $Recipient `
            -String
        AllocatedFunds = Get-CardanoTransactionAllocationValue `
            -Transaction $Transaction `
            -Recipient $Recipient `
            -PolicyId '' `
            -Name 'lovelace' `
            ??= 0
        AllocatedFees = Get-CardanoTransactionAllocationFee `
            -Transaction $Transaction `
            -Recipient $Recipient
        Balance = Get-CardanoTransactionAllocationFeeBalance `
            -Transaction $Transaction `
            -Recipient $Recipient
        Covered = Test-CardanoTransactionAllocationFeeCovered `
            -Transaction $Transaction `
            -Recipient $Recipient
        Recipient = $Recipient
    }
}