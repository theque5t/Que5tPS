function Initialize-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient
    )    
    Set-CardanoTransactionChangeAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -FeePercentage 0
}
