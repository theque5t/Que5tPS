function Set-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Assert-CardanoAddressIsValid $_ })]
        [string]$Recipient
    )
    $Transaction.ChangeRecipient = $Recipient
    $Transaction | Update-CardanoTransactionState
}
