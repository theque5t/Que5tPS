function Get-CardanoTransactionStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $transactionStatus = [PSCustomObject]@{
        Balanced = Test-CardanoTransactionIsBalanced -Transaction $Transaction
        FeeCovered = Test-CardanoTransactionFeeCovered -Transaction $Transaction
        Signed = Test-CardanoTransactionIsSigned -Transaction $Transaction
        Submitted = Test-CardanoTransactionIsSubmitted -Transaction $Transaction
    }
    return $transactionStatus
}
