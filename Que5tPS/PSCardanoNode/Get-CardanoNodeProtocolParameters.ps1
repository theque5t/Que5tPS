function Get-CardanoNodeProtocolParameters{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $envProtocalVar = "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_PROTOCOL_PARAMETERS"
    if($(Test-Path $envProtocalVar)){
        $protocolParams = $(Get-Item $envProtocalVar).Value
    }
    return $protocolParams
}
