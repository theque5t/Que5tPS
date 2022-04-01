function Update-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = $(Get-CardanoTransactionMinimumFee -Transaction $Transaction),
        [securestring[]]$SigningKeys
    )
    Update-CardanoTransactionState -Transaction $Transaction
    Update-CardanoTransactionBody -Transaction $Transaction -Fee $Fee
    Update-CardanoTransactionSigned -Transaction $Transaction -SigningKeys $SigningKeys
}
