function Close-CardanoNodeSession {
    [CmdletBinding()]
    param()
    Assert-CardanoNodeSessionIsOpen

    Write-VerboseLog 'Closing Cardano node session...'
    
    Set-CardanoNodeProcessStopped
    @('DEADALUS_HOME',
      'CARDANO_NODE_NETWORK',
      'CARDANO_CLI_NETWORK_ARG',
      'CARDANO_CLI_NETWORK_ARG_VALUE'
      'CARDANO_NODE_SESSION'
      'CARDANO_NODE_SOCKET_PATH'
    ).ForEach({ Remove-Item "env:\$_" })
    
    Assert-CardanoNodeSessionIsClosed
    Write-VerboseLog 'Cardano node session closed'
}
