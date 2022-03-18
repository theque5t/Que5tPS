function Set-CardanoTransactionAllocation {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value
    )
    Remove-CardanoTransactionAllocation -Transaction $Transaction `
        -Recipient $Recipient `

    Add-CardanoTransactionAllocation -Transaction $Transaction `
        -Recipient $Recipient `
        -Value $Value
}
