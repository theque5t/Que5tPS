function Set-CardanoTransactionFeeAllocationPercentage {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.FeeAllocations.Recipient 
        })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -ge 0 -and $_ -le $($Transaction | Get-CardanoTransactionUnallocatedFeePercentage) 
        })]
        [int]$Percentage
    )
    $Transaction.FeeAllocations = $Transaction.FeeAllocations.Where({
        $_.Recipient -eq $Recipient
    }).Percentage = $Percentage / 100
}
