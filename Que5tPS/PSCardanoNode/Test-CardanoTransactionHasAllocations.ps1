function Test-CardanoTransactionHasAllocations {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionAllocations -Transaction $Transaction).Count
}
