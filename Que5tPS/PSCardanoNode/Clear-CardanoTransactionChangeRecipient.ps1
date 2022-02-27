function Clear-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.ChangeRecipient = ''
    $Transaction | Update-CardanoTransactionState
}
