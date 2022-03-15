function Set-CardanoTransactionFeeAllocation {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -ge 0 -and $_ -le $($Transaction | Get-CardanoTransactionUnallocatedFeePercentage) 
        })]
        [int]$Percentage
    )
    $Transaction | Remove-CardanoTransactionFeeAllocation `
        -Recipient $Recipient `

    $Transaction | Add-CardanoTransactionFeeAllocation `
        -Recipient $Recipient `
        -Percentage $Percentage
}
