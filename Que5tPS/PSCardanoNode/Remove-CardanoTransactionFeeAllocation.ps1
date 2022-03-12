function Remove-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.FeeAllocations.Recipient 
        })]
        [string]$Recipient
    )
    $Transaction.FeeAllocations = $Transaction.FeeAllocations.Where({
        $_.Recipient -ne $Recipient
    })
}
