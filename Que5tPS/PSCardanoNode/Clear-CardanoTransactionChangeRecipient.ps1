function Clear-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.ChangeRecipient = ''
    Update-CardanoTransactionState -Transaction $Transaction
}
