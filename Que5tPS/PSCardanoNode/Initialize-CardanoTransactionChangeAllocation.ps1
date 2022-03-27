function Initialize-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient,
        [bool]$UpdateState = $true
    )    
    Set-CardanoTransactionChangeAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -FeePercentage 0
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
