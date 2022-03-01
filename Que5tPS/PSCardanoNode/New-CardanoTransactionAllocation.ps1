function New-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
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
