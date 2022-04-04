function Test-CardanoTransactionSubmittable {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return [bool]$(
        $(Test-CardanoTransactionIsSigned -Transaction $Transaction) -and
        $(Test-CardanoTransactionSignedMatchesState -Transaction $Transaction)
    )
}
