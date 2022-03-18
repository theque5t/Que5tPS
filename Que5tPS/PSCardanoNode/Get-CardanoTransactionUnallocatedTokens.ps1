function Get-CardanoTransactionUnallocatedTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $tokenBalances = Get-CardanoTransactionTokenBalances -Transaction $Transaction
    $unallocatedTokens = $tokenBalances.Where({ $_.Quantity -gt 0 })
    return $unallocatedTokens
}
