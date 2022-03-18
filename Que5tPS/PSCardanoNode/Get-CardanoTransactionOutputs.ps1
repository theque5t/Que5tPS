function Get-CardanoTransactionOutputs {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    $outputs = [CardanoTransactionOutput[]]@()
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation
    $allocations.Where({
        $($_.Value.Quantity | Measure-Object -Sum).Sum -gt 0
    }).ForEach({
        $outputs += New-CardanoTransactionOutput -Allocation $_
    })
    return $outputs
}
