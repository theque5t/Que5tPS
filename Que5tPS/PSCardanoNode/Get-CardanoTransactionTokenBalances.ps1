function Get-CardanoTransactionTokenBalances {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $allocatedTokens = $Transaction | Get-CardanoTransactionAllocatedTokens
    $allocatedTokens.ForEach({ $_.Quantity = -$_.Quantity })
    $inputTokens = $Transaction | Get-CardanoTransactionInputTokens
    $tokenBalances = Merge-CardanoTokens $($inputTokens + $allocatedTokens)
    return $tokenBalances
}
