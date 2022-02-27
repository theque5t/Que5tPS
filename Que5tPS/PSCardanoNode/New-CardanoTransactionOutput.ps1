function New-CardanoTransactionOutput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [CardanoTransactionAllocation]$Allocation
    )
    $output = [CardanoTransactionOutput]::new()
    $output.Address = $Allocation.Recipient
    $output.Value = $Allocation.Value.Where({ $_.Quantity -gt 0 })
    return $output
}
