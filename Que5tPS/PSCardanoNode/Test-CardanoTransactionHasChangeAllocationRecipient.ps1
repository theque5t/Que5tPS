function Test-CardanoTransactionHasChangeAllocationRecipient {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionChangeAllocationRecipient -Transaction $Transaction).Count
}
