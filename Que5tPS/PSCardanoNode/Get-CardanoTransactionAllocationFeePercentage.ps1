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
    $allocation = Get-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient
    $allocationFeePercentage = $allocation.FeePercentage
    if($String){
        $allocationFeePercentage = $allocationFeePercentage.ToString('P')
    }
    return $allocationFeePercentage
}
