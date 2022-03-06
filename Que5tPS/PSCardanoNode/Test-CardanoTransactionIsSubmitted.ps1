function Test-CardanoTransactionIsSubmitted {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return $false
}
