function Remove-CardanoTransactionChangeRecipient {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction.ChangeRecipient = $null
}
