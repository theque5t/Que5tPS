function Get-CardanoTransactionInputsQuantity {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $(Get-CardanoTransactionInputs -Transaction $Transaction).Count
}
