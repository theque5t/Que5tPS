function Get-CardanoTransactionInputTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $inputs = Get-CardanoTransactionInputs -Transaction $Transaction
    $inputTokens = Merge-CardanoTokens -Tokens $inputs.Value
    return $inputTokens
}
