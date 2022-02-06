function Set-CardanoNodeProtocolParameters{
    [CmdletBinding()]
    param()
    $_args = @(
        'query', 'protocol-parameters'
        '--out-file', $env:CARDANO_NODE_PROTOCOL_PARAMETERS
        $env:CARDANO_CLI_NETWORK_ARG
        $env:CARDANO_CLI_NETWORK_ARG_VALUE
    )
    Invoke-CardanoCLI @_args
    Write-VerboseLog "Set Cardano node protocol parameters"
}
