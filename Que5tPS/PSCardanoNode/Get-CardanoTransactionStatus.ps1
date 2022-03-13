function Get-CardanoTransactionStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction
    )
    $transactionStatus = [PSCustomObject]@{
        Balanced = $Transaction | Test-CardanoTransactionIsBalanced
        FeeCovered = $Transaction | Test-CardanoTransactionFeeCovered
        Signed = $Transaction | Test-CardanoTransactionIsSigned
        Submitted = $Transaction | Test-CardanoTransactionIsSubmitted
    }
    return $transactionStatus
}
