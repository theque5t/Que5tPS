function Close-CardanoNodeSession {
    [CmdletBinding()]
    param()
    Assert-CardanoNodeSessionIsOpen

    Write-VerboseLog 'Closing Cardano node session...'
    
    Set-CardanoNodeProcessStopped
    @('env:\DEADALUS_HOME'
      'env:\CARDANO_NODE_NETWORK'
      'env:\CARDANO_CLI_NETWORK_ARG'
      'env:\CARDANO_CLI_NETWORK_ARG_VALUE'
      $env:CARDANO_NODE_PROTOCOL_PARAMETERS
      'env:\CARDANO_NODE_PROTOCOL_PARAMETERS'
      'env:\CARDANO_NODE_SESSION'
      'env:\CARDANO_NODE_SOCKET_PATH'
    ).ForEach({ Remove-Item "$_" })
    
    Assert-CardanoNodeSessionIsClosed
    Write-VerboseLog 'Cardano node session closed'
}
