function Register-CardanoNodeSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    New-Item -Path $("env:CARDANO_NODE_SESSION_$($Network.ToUpper())") `
             -Value $true |
             Out-Null
}
