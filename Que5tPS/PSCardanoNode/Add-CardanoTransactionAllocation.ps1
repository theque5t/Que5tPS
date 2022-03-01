function Add-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [CardanoTransactionAllocation]$Allocation
    )
    $Transaction.Allocations += $Allocation
}
