function Get-CardanoTransactionTokenBalances {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $allocatedTokens = $Transaction | Get-CardanoTransactionAllocatedTokens
    $inputTokens = $Transaction | Get-CardanoTransactionInputTokens
    $tokenBalances = Get-CardanoTokensDifference `
        -Set1 $inputTokens `
        -Set2 $allocatedTokens
    return $tokenBalances
}
