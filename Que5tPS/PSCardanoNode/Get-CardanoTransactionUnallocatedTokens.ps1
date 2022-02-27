function Get-CardanoTransactionUnallocatedTokens {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $tokenBalances = $Transaction | Get-CardanoTransactionTokenBalances
    $unallocatedTokens = $tokenBalances.Where({ $_.Quantity -gt 0 })
    return $unallocatedTokens
}
