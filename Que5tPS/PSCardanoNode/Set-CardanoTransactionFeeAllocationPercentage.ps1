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
        [int]$Percentage
    )
    $Transaction.FeeAllocations = $Transaction.FeeAllocations.Where({
        $_.Recipient -eq $Recipient
    }).Percentage = $Percentage / 100
}
