function Test-CardanoTransactionIsSigned {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(
        $Transaction.SignedBodyHash -eq 
        $(Get-CardanoTransactionBodyHash -Transaction $Transaction)
    )
}
