function Get-CardanoTransactionOutputTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $outputs = $Transaction | Get-CardanoTransactionOutputs
    $outputTokens = Merge-CardanoTokens -Tokens $outputs.Value
    return $outputTokens
}
