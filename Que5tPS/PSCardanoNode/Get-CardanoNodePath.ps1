function Get-CardanoNodePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $envNodeVar = "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_PATH"
    if($(Test-Path $envNodeVar)){
        $node = $(Get-Item $envNodeVar).Value
    }
    return $node
}
