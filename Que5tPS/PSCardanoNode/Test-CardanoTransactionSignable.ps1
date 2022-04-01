function Test-CardanoTransactionSignable {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return [bool]$(
        $(Test-CardanoTransactionHasInputs -Transaction $Transaction) -and
        $(Test-CardanoTransactionHasOutputs -Transaction $Transaction) -and
        $(Test-CardanoTransactionIsBalanced -Transaction $Transaction) -and
        $(Test-CardanoTransactionFeeCovered -Transaction $Transaction)
    )
}
