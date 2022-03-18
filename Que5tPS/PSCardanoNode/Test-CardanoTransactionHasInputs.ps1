function Test-CardanoTransactionHasInputs {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(Get-CardanoTransactionInputs -Transaction $Transaction).Count
}
