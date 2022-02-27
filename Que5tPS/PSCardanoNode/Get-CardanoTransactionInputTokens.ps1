function Get-CardanoTransactionInputTokens {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $inputs = $Transaction | Get-CardanoTransactionInputs
    $inputTokens = Merge-CardanoTokens $inputs.Value
    return $inputTokens
}
