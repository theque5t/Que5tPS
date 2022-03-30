function Update-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = $(Get-CardanoTransactionMinimumFee -Transaction $Transaction)
    )
    Update-CardanoTransactionState -Transaction $Transaction
    Update-CardanoTransactionBody -Transaction $Transaction -Fee $Fee
}
