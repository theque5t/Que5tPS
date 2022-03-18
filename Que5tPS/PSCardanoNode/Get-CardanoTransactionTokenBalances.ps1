function Get-CardanoTransactionTokenBalances {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $allocatedTokens = Get-CardanoTransactionAllocatedTokens -Transaction $Transaction
    $inputTokens = Get-CardanoTransactionInputTokens -Transaction $Transaction
    $tokenBalances = Get-CardanoTokensDifference `
        -Set1 $inputTokens `
        -Set2 $allocatedTokens
    return $tokenBalances
}
