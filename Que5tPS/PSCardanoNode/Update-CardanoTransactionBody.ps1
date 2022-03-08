function Update-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = 0
    )
    $Transaction | Export-CardanoTransactionBody -Fee $Fee
    $Transaction | Import-CardanoTransactionBody
}
