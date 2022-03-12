function Set-CardanoTransactionFeeFeeAllocation {
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
    $Transaction | Remove-CardanoTransactionFeeAllocation `
        -Recipient $Recipient `

    $Transaction | Add-CardanoTransactionFeeAllocation `
        -Recipient $Recipient `
        -Percentage $Percentage
}
