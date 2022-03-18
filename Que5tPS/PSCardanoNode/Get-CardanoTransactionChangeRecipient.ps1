function Get-CardanoTransactionChangeRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.ChangeRecipient
}
