function Test-CardanoTransactionHasAllocatedTokens {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionAllocatedTokens -Transaction $Transaction).Count
}
