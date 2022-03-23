function Initialize-CardanoTransactionAllocations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage
    )    
    Set-CardanoTransactionChangeAllocation -Transaction $Transaction `
        -Recipient $Recipient `
        -FeePercentage 0
}
