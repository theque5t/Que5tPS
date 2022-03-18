function Get-CardanoTransactionOutputTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $outputs = Get-CardanoTransactionOutputs -Transaction $Transaction
    $outputTokens = Merge-CardanoTokens -Tokens $outputs.Value
    return $outputTokens
}
