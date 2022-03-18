function Set-CardanoTransactionFeeAllocationPercentage {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.FeeAllocations.Recipient 
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_percentage = $_/100
            $_percentage -ge 0 -and 
            $_percentage -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$Percentage
    )
    $($Transaction.FeeAllocations.Where({
        $_.Recipient -eq $Recipient
    })).Percentage = $Percentage / 100
}
