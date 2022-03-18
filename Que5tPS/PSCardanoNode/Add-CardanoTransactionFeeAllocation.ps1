function Add-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
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
    $Transaction.FeeAllocations += New-CardanoTransactionFeeAllocation `
        -Recipient $recipient `
        -Percentage $Percentage
}
