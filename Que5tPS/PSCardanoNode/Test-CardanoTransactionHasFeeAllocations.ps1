function Test-CardanoTransactionHasFeeAllocations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionFeeAllocations -Transaction $Transaction).Count
}
