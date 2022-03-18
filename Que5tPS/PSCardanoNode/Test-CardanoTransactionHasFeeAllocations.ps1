function Test-CardanoTransactionHasFeeAllocations {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionFeeAllocations -Transaction $Transaction).Count
}
