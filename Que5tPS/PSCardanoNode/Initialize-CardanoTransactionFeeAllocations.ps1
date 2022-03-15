function Initialize-CardanoTransactionFeeAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string[]]$Recipients
    )
    $Recipients.ForEach({
        $Transaction | Set-CardanoTransactionFeeAllocation `
            -Recipient $_ `
            -Percentage 0
    })
}
