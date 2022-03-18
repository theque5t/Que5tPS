function Update-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = 0      
    )
    Update-CardanoTransactionState -Transaction $Transaction
    Update-CardanoTransactionBody -Transaction $Transaction -Fee $Fee
}
