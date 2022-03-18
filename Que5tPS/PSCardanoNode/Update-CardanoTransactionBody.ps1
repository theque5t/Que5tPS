function Update-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = 0
    )
    Export-CardanoTransactionBody -Transaction $Transaction -Fee $Fee
    Import-CardanoTransactionBody -Transaction $Transaction
}
