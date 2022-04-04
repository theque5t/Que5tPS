function Get-CardanoTransactionSubmissionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.Submitted
}
