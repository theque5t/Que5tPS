function Set-CardanoTransactionName {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory=$true)]
        $Name,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Name = $Name
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
