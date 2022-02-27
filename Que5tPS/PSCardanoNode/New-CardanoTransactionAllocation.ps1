function New-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value
    )
    $allocation = [CardanoTransactionAllocation]::new()
    $allocation.Recipient = $Recipient
    $allocation.Value = $Value
    return $allocation
}
