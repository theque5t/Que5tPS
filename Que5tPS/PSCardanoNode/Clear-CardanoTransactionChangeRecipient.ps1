function Clear-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.ChangeRecipient = ''
    Update-CardanoTransactionState -Transaction $Transaction
}
