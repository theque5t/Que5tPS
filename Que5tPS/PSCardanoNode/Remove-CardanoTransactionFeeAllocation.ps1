function Remove-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient
    )
    $Transaction.FeeAllocations = $Transaction.FeeAllocations.Where({
        $_.Recipient -ne $Recipient
    })
}
