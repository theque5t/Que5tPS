function Test-CardanoTransactionHasChangeAllocation {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionChangeAllocation -Transaction $Transaction).Count
}
