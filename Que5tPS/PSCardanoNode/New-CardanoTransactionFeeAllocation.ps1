function New-CardanoTransactionFeeAllocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$Percentage
    )
    $feeAllocation = New-Object CardanoTransactionFeeAllocation -Property @{
        Recipient = $Recipient
        Percentage = $Percentage / 100
    }
    return $feeAllocation
}
