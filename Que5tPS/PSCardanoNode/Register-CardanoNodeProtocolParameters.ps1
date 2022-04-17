function Register-CardanoNodeProtocolParameters{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $envSessionProtocolParamsVar = $(
        "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_PROTOCOL_PARAMETERS"
    )
    New-Item -Path $envSessionProtocolParamsVar `
             -Value "$env:CARDANO_HOME\protocolParameters-$($(New-Guid).Guid).json" |
             Out-Null
    $socket = Get-CardanoNodeSocket -Network $Network
    $nodePath = Get-CardanoNodePath -Network $Network
    $protocolParams = Get-CardanoNodeProtocolParameters -Network $Network
    $networkArgs = Get-CardanoNodeNetworkArg -Network $Network
    $_args = @(
        'query', 'protocol-parameters'
        '--out-file', $protocolParams
        $networkArgs
    )
    Invoke-CardanoCLI `
        -Socket $socket `
        -Path $nodePath `
        -Arguments $_args
    Write-VerboseLog `
        "Registered Cardano node protocol parameters to $($(Get-Item $envSessionProtocolParamsVar).Value)"
}
