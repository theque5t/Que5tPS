function Test-CardanoTransactionHasOutputs {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$($Transaction | Get-CardanoTransactionOutputs).Count
}
