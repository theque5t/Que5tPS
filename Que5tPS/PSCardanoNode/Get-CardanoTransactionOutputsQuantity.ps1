function Get-CardanoTransactionOutputsQuantity {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = $(Get-CardanoTransactionMinimumFee -Transaction $Transaction)
    )
    return $(Get-CardanoTransactionOutputs -Transaction $Transaction -Fee $Fee).Count
}
