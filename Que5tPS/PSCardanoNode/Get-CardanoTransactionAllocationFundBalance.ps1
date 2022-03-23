function Get-CardanoTransactionAllocationFundBalance {
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
    $allocatedFunds = $(Get-CardanoTransactionAllocationValue `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -PolicyId '' `
        -Name 'lovelace').Quantity ?? 0
    $allocatedFees = Get-CardanoTransactionAllocationFee `
        -Transaction $Transaction `
        -Recipient $Recipient
    $fundBalance = $allocatedFunds - $allocatedFees
    return $fundBalance
}