function Get-CardanoNodeProtocolParameters{
    [CmdletBinding()]
    param()
    Assert-CardanoNodeSessionIsOpen
    Write-VerboseLog "Getting node protocol parameters..."
    $parameters = Get-Content -Path $env:CARDANO_NODE_PROTOCOL_PARAMETERS |
                  ConvertFrom-Json
    return $parameters
}
