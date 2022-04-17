function Unregister-CardanoNodePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Remove-Item "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_PATH"
}
