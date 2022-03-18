function Remove-CardanoTransactionChangeRecipient {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.ChangeRecipient = $null
}
