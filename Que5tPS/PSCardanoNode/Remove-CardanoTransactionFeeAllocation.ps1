function Remove-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient
    )
    $Transaction.FeeAllocations = $Transaction.FeeAllocations.Where({
        $_.Recipient -ne $Recipient
    })
}
