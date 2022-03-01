function New-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Assert-CardanoAddressIsValid $_ })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value
    )
    $allocation = New-Object CardanoTransactionAllocation -Property @{
        Recipient = $Recipient
        Value = $Value
    }
    return $allocation
}
