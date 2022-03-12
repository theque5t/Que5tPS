function Add-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, PercentageFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [int]$Percentage
    )
    $Transaction.FeeAllocations += New-CardanoTransactionFeeAllocation `
        -Recipient $recipient `
        -Percentage $Percentage
}
