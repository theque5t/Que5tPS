function Clear-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.ChangeRecipient = ''
    $Transaction | Update-CardanoTransactionState
}
