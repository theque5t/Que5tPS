function Set-CardanoTransactionNetwork {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $Transaction.Network = $Network
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
