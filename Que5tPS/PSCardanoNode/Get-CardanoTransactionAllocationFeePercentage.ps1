function Get-CardanoTransactionAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
        [string]$Recipient,
        [switch]$String
    )
    $feeAllocation = Get-CardanoTransactionFeeAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient
    $allocationFeePercentage = $feeAllocation.Percentage
    if($String){
        $allocationFeePercentage = $allocationFeePercentage.ToString('P')
    }
    return $allocationFeePercentage
}
