function Get-CardanoTransactionOutputs {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = $(Get-CardanoTransactionMinimumFee -Transaction $Transaction)
    )
    $outputs = [CardanoTransactionOutput[]]@()
    $allocations = Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation
    $allocations.ForEach({
        $outputs += New-CardanoTransactionOutput `
            -Allocation $_ `
            -Fee $Fee
    })
    return $outputs
}
