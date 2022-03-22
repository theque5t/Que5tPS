function Set-CardanoTransactionAllocation {
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
    Remove-CardanoTransactionAllocation -Transaction $Transaction `
        -Recipient $Recipient `

    Add-CardanoTransactionAllocation -Transaction $Transaction `
        -Recipient $Recipient `
        -Value $Value `
        -FeePercentage $FeePercentage
}
