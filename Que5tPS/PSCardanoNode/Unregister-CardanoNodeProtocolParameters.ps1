function Unregister-CardanoNodeProtocolParameters {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Remove-Item $(Get-CardanoNodeProtocolParameters -Network $Network)
    Remove-Item "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_PROTOCOL_PARAMETERS"
}
