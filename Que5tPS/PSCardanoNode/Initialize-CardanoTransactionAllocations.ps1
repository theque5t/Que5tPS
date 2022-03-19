function Initialize-CardanoTransactionAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string[]]$Recipients
    )
    
    $value = Get-CardanoTransactionInputTokens -Transaction $Transaction
    $value.ForEach({ $_.Quantity = 0 })
    $Recipients.ForEach({
        Set-CardanoTransactionAllocation -Transaction $Transaction `
            -Recipient $_ `
            -Value $value `
            -FeePercentage 0
    })
}
