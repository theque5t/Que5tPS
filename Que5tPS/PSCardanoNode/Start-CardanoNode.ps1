function Start-CardanoNode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Deadalus')]
        $NodeType
    )
    Write-VerboseLog 'Starting Cardano...'
        
    Register-CardanoNodePath -Network $Network -NodeType $NodeType

    if(-not $(Test-CardanoNodeIsRunning -Network $Network)){
        $nodePath = Get-CardanoNodePath -Network $Network
        Start-Process `
            -FilePath "$nodePath\cardano-launcher.exe" `
            -WorkingDirectory $nodePath
    }
    
    Wait-CardanoNodeRunning -Network $Network

    Register-CardanoNodeSocketPath -Network $Network

    Wait-CardanoNodeResponding -Network $Network

    Register-CardanoNodeProtocolParameters -Network $Network

    Assert-CardanoNodeStarted -Network $Network

    Write-VerboseLog 'Cardano node started'
}
