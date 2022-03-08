function Get-CardanoTransactionOutputs {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $outputs = [CardanoTransactionOutput[]]@()
    $allocations = $Transaction | Get-CardanoTransactionAllocations
    $changeAllocation = $Transaction | Get-CardanoTransactionChangeAllocation
    @($allocations, $changeAllocation).Where({
        $($_.Value.Quantity | Measure-Object -Sum).Sum -gt 0
    }).ForEach({
        $outputs += New-CardanoTransactionOutput -Allocation $_
    })
    return $outputs
}
