function Test-CardanoTransactionIsBalanced {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $inputTokens = Get-CardanoTransactionInputTokens -Transaction $Transaction
    $outputTokens = Get-CardanoTransactionOutputTokens -Transaction $Transaction
    $inputOutputTokensDifference = $(
        Get-CardanoTokensDifference `
            -Set1 $inputTokens `
            -Set2 $outputTokens
    ).Where({ $_.Quantity -gt 0 }).Count
    return -not $inputOutputTokensDifference
}
