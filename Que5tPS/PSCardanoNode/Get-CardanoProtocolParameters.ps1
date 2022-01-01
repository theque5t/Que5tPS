function Get-CardanoProtocolParameters {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $OutputFile
    )    
    Assert-CardanoNodeInSync
    Write-VerboseLog "Getting protocol parameters..."

    $_args = @(
        'query','protocol-parameters'
        '--out-file', $outputFile
        $env:CARDANO_CLI_NETWORK_ARG
        $env:CARDANO_CLI_NETWORK_ARG_VALUE
    )
    Invoke-CardanoCLI @_args
}
