function Test-CardanoTransactionIsBalanced {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $inputTokens = Get-CardanoTransactionInputTokens -Transaction $Transaction
    $outputTokens = Get-CardanoTransactionOutputTokens -Transaction $Transaction
    $feeTokens = Get-CardanoTransactionMinimumFee -Transaction $Transaction -Token
    $outputAndFeeTokens = Merge-CardanoTokens -Tokens @($outputTokens, $feeTokens)
    $inputOutputTokensDifference = [bool]$(
        Get-CardanoTokensDifference `
            -Set1 $inputTokens `
            -Set2 $outputAndFeeTokens
        ).Where({ $_.Quantity -ne 0 }).Count
    return -not $inputOutputTokensDifference
}
