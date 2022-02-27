function Set-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [ValidateScript({ Assert-CardanoAddressIsValid $_ })]
        [string]$Recipient
    )
    $Transaction.ChangeRecipient = $Recipient
    $Transaction | Update-CardanoTransactionState
}
