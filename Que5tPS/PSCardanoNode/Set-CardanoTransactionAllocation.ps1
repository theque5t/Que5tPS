function Set-CardanoTransactionAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 0 -and $_ -le 100 })]
        [int]$FeePercentage
    )
    Remove-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `

    Add-CardanoTransactionAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -Value $Value `
        -FeePercentage $FeePercentage
}
