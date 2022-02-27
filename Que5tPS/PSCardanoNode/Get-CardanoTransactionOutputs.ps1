function Get-CardanoTransactionOutputs {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $outputs = [CardanoTransactionOutput[]]@()
    $allocations = $Transaction | Get-CardanoTransactionAllocations
    $changeAllocation = $Transaction | Get-CardanoTransactionChangeAllocation
    $($allocations + $changeAllocation).Where({
        $($_.Value.Quantity | Measure-Object -Sum).Sum -gt 0
    }).ForEach({
        $outputs += [CardanoTransactionOutput]::new($_)
    })
    return $outputs
}
