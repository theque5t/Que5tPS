function Test-CardanoTransactionHasAllocations {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$($Transaction | Get-CardanoTransactionAllocations).Count
}
