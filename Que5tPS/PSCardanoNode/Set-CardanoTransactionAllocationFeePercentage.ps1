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
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $percentage = ConvertTo-RoundNumber `
        -Number $($FeePercentage / 100) `
        -DecimalPlaces 2
    if($Recipient -in $Transaction.Allocations.Recipient){
        $allocation = Get-CardanoTransactionAllocation `
            -Transaction $Transaction `
            -Recipient $Recipient
        $allocation.FeePercentage = $percentage
    }
    if($Recipient -eq $Transaction.ChangeAllocation.Recipient){
        $Transaction.ChangeAllocation.FeePercentage = $percentage
    }
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
