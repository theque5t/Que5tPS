function Get-CardanoTransactionChangeAllocationRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    return $Transaction.ChangeAllocation.Recipient
}
