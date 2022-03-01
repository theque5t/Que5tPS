function Update-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [Int64]$Fee = 0
    )
    $Transaction | Export-CardanoTransactionBody -Fee $Fee
    $Transaction | Import-CardanoTransactionBody
}
