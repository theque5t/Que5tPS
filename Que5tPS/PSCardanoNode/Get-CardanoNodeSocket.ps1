function Get-CardanoNodeSocket {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $envSocketVar = "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_SOCKET"
    if($(Test-Path $envSocketVar)){
        $socket = $(Get-Item $envSocketVar).Value
    }
    return $socket
}
