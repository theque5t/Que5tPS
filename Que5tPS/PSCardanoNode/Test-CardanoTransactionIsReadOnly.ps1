function Test-CardanoTransactionIsReadOnly {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return Test-CardanoTransactionIsSubmitted -Transaction $Transaction
}
