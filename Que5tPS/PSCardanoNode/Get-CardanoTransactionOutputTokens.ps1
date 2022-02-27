function Get-CardanoTransactionOutputTokens {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $outputs = $Transaction | Get-CardanoTransactionOutputs
    $outputTokens = Merge-CardanoTokens $outputs.Value
    return $outputTokens
}
