function New-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage
    )
    $allocation = New-Object CardanoTransactionAllocation -Property @{
        Recipient = $Recipient
        Value = $Value
        FeePercentage = $FeePercentage / 100
    }
    return $allocation
}
