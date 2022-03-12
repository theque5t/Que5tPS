function Get-CardanoTransactionFeeAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.FeeAllocations
}
