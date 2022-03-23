function New-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage
    )
    $changeAllocation = New-Object CardanoTransactionChangeAllocation -Property @{
        Recipient = $Recipient
        FeePercentage = $FeePercentage / 100
    }
    return $changeAllocation
}
