function Update-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = 0
    )
    $Transaction | Export-CardanoTransactionBody $Fee
    $Transaction | Import-CardanoTransactionBody
}
