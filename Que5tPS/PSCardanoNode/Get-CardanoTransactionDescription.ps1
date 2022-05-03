function Get-CardanoTransactionDescription {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.Description
}
