function Add-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value
    )
    $Transaction.Allocations += New-CardanoTransactionAllocation `
        -Recipient $recipient `
        -Value $Value
}
