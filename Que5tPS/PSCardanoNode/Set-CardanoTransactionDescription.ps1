function Set-CardanoTransactionDescription {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory=$true)]
        $Description,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Description = $Description
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
