function Test-CardanoTransactionIsSigned {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return $false
}
