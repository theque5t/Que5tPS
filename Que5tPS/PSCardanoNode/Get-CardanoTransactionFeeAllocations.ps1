function Get-CardanoTransactionFeeAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.FeeAllocations
}
