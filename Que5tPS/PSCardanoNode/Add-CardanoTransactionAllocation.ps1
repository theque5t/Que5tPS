function Add-CardanoTransactionAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $percentage = $_/100
            $percentage -ge 0 -and 
            $percentage -le $(Get-CardanoTransactionUnallocatedFeePercentage -Transaction $Transaction) 
        })]
        [int]$FeePercentage
    )
    $Transaction.Allocations += New-CardanoTransactionAllocation `
        -Recipient $recipient `
        -Value $Value `
        -FeePercentage $FeePercentage
}
