function Test-CardanoTransactionHasChangeRecipient {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$($Transaction | Get-CardanoTransactionChangeRecipient).Count
}
