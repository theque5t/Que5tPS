function Initialize-CardanoTransactionAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string[]]$Recipients
    )
    
    $value = $Transaction | Get-CardanoTransactionInputTokens
    $value.ForEach({ $_.Quantity = 0 })
    $Recipients.ForEach({
        $Transaction | Set-CardanoTransactionAllocation `
            -Recipient $_ `
            -Value $value
    })
}
