function Set-CardanoTransactionChangeAllocationRecipient {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient
    )
    $Transaction.ChangeAllocation.Recipient = $Recipient
}
