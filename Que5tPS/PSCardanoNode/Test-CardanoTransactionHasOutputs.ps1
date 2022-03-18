function Test-CardanoTransactionHasOutputs {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionOutputs -Transaction $Transaction).Count
}
