function Set-CardanoTransactionAllocation {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ 
            $_ -in $Transaction.Allocations.Recipient 
        })]
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
