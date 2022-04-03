function Get-CardanoTransactionStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    $transactionStatus = [PSCustomObject]@{
        InputQuantity = Get-CardanoTransactionInputsQuantity -Transaction $Transaction
        OutputQuantity = Get-CardanoTransactionOutputsQuantity -Transaction $Transaction
        WitnessQuantity = Get-CardanoTransactionWitnessQuantity -Transaction $Transaction
        Fee = Get-CardanoTransactionMinimumFee -Transaction $Transaction
        Balanced = Test-CardanoTransactionIsBalanced -Transaction $Transaction
        FeeCovered = Test-CardanoTransactionFeeCovered -Transaction $Transaction
        Signed = Test-CardanoTransactionIsSigned -Transaction $Transaction
        Submitted = Test-CardanoTransactionIsSubmitted -Transaction $Transaction
    }
    return $transactionStatus
}
