function New-CardanoTransactionOutput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [CardanoTransactionAllocation]$Allocation,
        [Parameter(Mandatory = $true)]
        [Int64]$Fee
    )
    $allocationFee = Measure-CardanoTransactionAllocatedFee `
        -Fee $Fee `
        -Percentage $Allocation.FeePercentage
    $allocationFee = New-CardanoToken `
        -PolicyId '' `
        -Name 'lovelace' `
        -Quantity $allocationFee
    $value = Get-CardanoTokensDifference `
        -Set1 $Allocation.Value `
        -Set2 $allocationFee
    $value = $value.Where({ $_.Quantity -gt 0 })

    if($($value.Quantity | Measure-Object -Sum).Sum -gt 0){
        return New-Object CardanoTransactionOutput -Property @{
            Address = $Allocation.Recipient
            Value = $value
        }
    }
}
