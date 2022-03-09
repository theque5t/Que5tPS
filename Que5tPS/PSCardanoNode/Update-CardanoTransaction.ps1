function Update-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = 0      
    )
    $Transaction | Update-CardanoTransactionState
    $Transaction | Update-CardanoTransactionBody -Fee $Fee
}
