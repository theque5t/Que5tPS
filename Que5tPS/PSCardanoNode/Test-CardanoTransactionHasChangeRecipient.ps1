function Test-CardanoTransactionHasChangeRecipient {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionChangeRecipient -Transaction $Transaction).Count
}
