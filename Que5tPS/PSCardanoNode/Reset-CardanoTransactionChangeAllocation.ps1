function Reset-CardanoTransactionChangeAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    Set-CardanoTransactionChangeAllocation `
        -Transaction $Transaction `
        -Recipient '' `
        -FeePercentage 0
}
