function Reset-CardanoTransactionChangeAllocation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [bool]$UpdateState = $true
    )
    Set-CardanoTransactionChangeAllocation `
        -Transaction $Transaction `
        -Recipient '' `
        -FeePercentage 0
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
