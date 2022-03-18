function Test-CardanoTransactionHasInputs {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionInputs -Transaction $Transaction).Count
}
