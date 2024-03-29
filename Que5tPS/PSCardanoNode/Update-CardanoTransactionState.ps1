function Update-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    Export-CardanoTransactionState `
        -Transaction $Transaction `
        -ROProtection $ROProtection
    Import-CardanoTransactionState -Transaction $Transaction
}
