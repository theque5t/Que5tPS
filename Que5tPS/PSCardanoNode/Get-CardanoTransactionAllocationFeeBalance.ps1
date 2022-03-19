function Get-CardanoTransactionAllocationFeeBalance {
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
    $allocatedFunds = Get-CardanoTransactionAllocationValue `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -PolicyId '' `
        -Name 'lovelace' `
        ??= 0
    $allocatedFees = Get-CardanoTransactionAllocationFee `
        -Transaction $Transaction `
        -Recipient $Recipient
    $feeBalance = $allocatedFunds - $allocatedFees
    return $feeBalance
}