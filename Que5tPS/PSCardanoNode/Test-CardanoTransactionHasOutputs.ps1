function Test-CardanoTransactionHasOutputs {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionOutputs -Transaction $Transaction).Count
}
