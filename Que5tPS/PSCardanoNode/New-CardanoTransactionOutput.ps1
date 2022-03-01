function New-CardanoTransactionOutput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [CardanoTransactionAllocation]$Allocation
    )
    $output = New-Object CardanoTransactionOutput -Property @{
        Address = $Allocation.Recipient
        Value = $Allocation.Value.Where({ $_.Quantity -gt 0 })
    }
    return $output
}
