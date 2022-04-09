function Initialize-CardanoTransactionChangeAllocation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Recipient,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    Set-CardanoTransactionChangeAllocation `
        -Transaction $Transaction `
        -Recipient $Recipient `
        -FeePercentage 0 `
        -UpdateState $False
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
