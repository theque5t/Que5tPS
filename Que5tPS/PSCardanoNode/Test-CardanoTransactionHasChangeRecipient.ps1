function Test-CardanoTransactionHasChangeRecipient {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionChangeRecipient -Transaction $Transaction).Count
}
