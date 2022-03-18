function Test-CardanoTransactionHasAllocations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionAllocations -Transaction $Transaction).Count
}
