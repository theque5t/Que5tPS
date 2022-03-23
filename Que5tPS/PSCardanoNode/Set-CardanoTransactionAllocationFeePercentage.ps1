function Set-CardanoTransactionAllocationFeePercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient -or
            $_ -eq $Transaction.ChangeAllocation.Recipient
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_percentage = $_/100
            $_percentage -ge 0 -and 
            $_percentage -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$FeePercentage
    )
    $percentage = ConvertTo-RoundNumber `
        -Number $($FeePercentage / 100) `
        -DecimalPlaces 2
    if($Recipient -in $Transaction.Allocations.Recipient){
        $allocation = Get-CardanoTransactionAllocation `
            -Transaction $Transaction `
            -Recipient $Recipient
        $allocation.FeePercentage = $percentage
    }
    if($_ -eq $Transaction.ChangeAllocation.Recipient){
        $Transaction.ChangeAllocation.FeePercentage = $percentage
    }
}
