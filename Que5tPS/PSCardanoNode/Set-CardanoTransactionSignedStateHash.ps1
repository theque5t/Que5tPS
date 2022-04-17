function Set-CardanoTransactionSignedStateHash {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Hash,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.SignedStateHash = $Hash
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
