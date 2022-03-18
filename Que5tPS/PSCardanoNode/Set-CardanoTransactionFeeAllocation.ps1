function Set-CardanoTransactionFeeAllocation {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -ge 0 -and $_ -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$Percentage
    )
    Remove-CardanoTransactionFeeAllocation -Transaction $Transaction `
        -Recipient $Recipient `

    Add-CardanoTransactionFeeAllocation -Transaction $Transaction `
        -Recipient $Recipient `
        -Percentage $Percentage
}
