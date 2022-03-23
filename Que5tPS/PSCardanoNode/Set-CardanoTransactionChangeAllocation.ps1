function Set-CardanoTransactionChangeAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $percentage = $_/100
            $percentage -ge 0 -and 
            $percentage -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$FeePercentage
    )
    $Transaction.ChangeAllocation = New-CardanoTransactionChangeAllocation `
        -Recipient $Recipient `
        -FeePercentage $FeePercentage
}
