function Test-CardanoTransactionIsSigned {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return $false
}
