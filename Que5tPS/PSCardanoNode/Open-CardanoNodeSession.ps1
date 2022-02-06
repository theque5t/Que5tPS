function Open-CardanoNodeSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Assert-CardanoNodeSessionIsClosed

    Write-VerboseLog 'Opening Cardano node session...'
    
    $env:DEADALUS_HOME = "C:\Program Files\Daedalus $Network"
    
    $env:CARDANO_NODE_NETWORK = $Network
    $env:CARDANO_CLI_NETWORK_ARG = "--$Network"
    $env:CARDANO_CLI_NETWORK_ARG_VALUE = ''
    switch ($Network) {
        'testnet' {
            $env:CARDANO_CLI_NETWORK_ARG = "--$Network-magic"
            $env:CARDANO_CLI_NETWORK_ARG_VALUE = 1097911063
        }
    }

    Set-CardanoNodeProcessRunning
    Set-CardanoNodeSocketPath

    do{
        Write-VerboseLog 'Waiting for Cardano node to respond...'
        Start-Sleep -Seconds 5
    }
    while(-not $(Get-CardanoNodeTip))

    $env:CARDANO_NODE_PROTOCOL_PARAMETERS = "$env:CARDANO_HOME\protocolParameters-$($(New-Guid).Guid).json" 
    Set-CardanoNodeProtocolParameters

    $env:CARDANO_NODE_SESSION = $true

    Assert-CardanoNodeSessionIsOpen
    Write-VerboseLog 'Cardano node session opened'
}
