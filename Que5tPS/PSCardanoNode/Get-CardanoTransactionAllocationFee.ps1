function Get-CardanoTransactionAllocationFee {
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
    $minimumFee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
    $feePercentage = Get-CardanoTransactionAllocationFeePercentage `
        -Transaction $Transaction `
        -Recipient $Recipient
    $allocationFee = $minimumFee * $feePercentage
    return $allocationFee
}
