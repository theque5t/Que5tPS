function Get-CardanoTransactionInputTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $inputs = $Transaction | Get-CardanoTransactionInputs
    $inputTokens = Merge-CardanoTokens -Tokens $inputs.Value
    return $inputTokens
}
