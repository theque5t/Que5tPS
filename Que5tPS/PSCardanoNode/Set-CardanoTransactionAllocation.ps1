function Set-CardanoTransactionAllocation {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [CardanoToken[]]$Value
    )
    $Transaction | Remove-CardanoTransactionAllocation `
        -Recipient $Recipient `

    $Transaction | Add-CardanoTransactionAllocation `
        -Recipient $Recipient `
        -Value $Value
}
