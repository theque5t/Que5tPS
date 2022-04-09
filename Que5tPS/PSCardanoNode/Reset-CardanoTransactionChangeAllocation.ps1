function Reset-CardanoTransactionChangeAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    Set-CardanoTransactionChangeAllocation `
        -Transaction $Transaction `
        -Recipient '' `
        -FeePercentage 0 `
        -UpdateState $False
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
