function Test-CardanoTransactionIsSubmitted {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return Get-CardanoTransactionSubmissionState -Transaction $Transaction
}
