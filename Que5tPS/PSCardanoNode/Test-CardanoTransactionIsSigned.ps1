function Test-CardanoTransactionIsSigned {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return [bool]$(
        $Transaction.SignedStateHash -eq 
        $(Get-CardanoTransactionStateHash -Transaction $Transaction)
    )
}
