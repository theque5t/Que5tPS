function Test-CardanoTransactionHasChangeAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionChangeAllocation -Transaction $Transaction).Count
}
