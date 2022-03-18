function Initialize-CardanoTransactionFeeAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [string[]]$Recipients
    )
    $Recipients.ForEach({
        Set-CardanoTransactionFeeAllocation -Transaction $Transaction `
            -Recipient $_ `
            -Percentage 0
    })
}
