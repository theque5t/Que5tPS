function Get-CardanoTransactionAllocationFee {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient,
        [switch]$Token
    )
    $minimumFee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
    $feePercentage = Get-CardanoTransactionAllocationFeePercentage `
        -Transaction $Transaction `
        -Recipient $Recipient
    $allocationFee = Measure-CardanoTransactionAllocatedFee `
        -Fee $minimumFee `
        -Percentage $feePercentage
    if($Token){
        $allocationFee = New-CardanoToken `
            -PolicyId '' `
            -Name 'lovelace' `
            -Quantity $allocationFee
    }
    return $allocationFee
}
