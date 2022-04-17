function Test-CardanoNodeSessionIsOpen {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    return Test-Path $("env:CARDANO_NODE_SESSION_$($Network.ToUpper())")
}
