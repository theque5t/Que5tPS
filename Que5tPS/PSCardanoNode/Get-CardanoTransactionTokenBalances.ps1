function Get-CardanoTransactionTokenBalances {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $allocatedTokens = $Transaction | Get-CardanoTransactionAllocatedTokens
    $allocatedTokens.ForEach({ $_.Quantity = -$_.Quantity })
    $inputTokens = $Transaction | Get-CardanoTransactionInputTokens
    $tokenBalances = Merge-CardanoTokens -Tokens $($inputTokens + $allocatedTokens)
    return $tokenBalances
}
