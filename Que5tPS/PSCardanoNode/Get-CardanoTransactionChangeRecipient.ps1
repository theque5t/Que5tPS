function Get-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.ChangeRecipient
}
