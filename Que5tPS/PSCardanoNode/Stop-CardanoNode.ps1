function Stop-CardanoNode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Write-VerboseLog 'Stopping Cardano node...'
    
    if($(Test-CardanoNodeIsRunning -Network $Network)){
        $nodePath = Get-CardanoNodePath -Network $Network
        $nodeProcess = $(Get-Process).Where({
            $_.Path -like "$nodePath\*"
        })
        $nodeProcess | Stop-Process
    }

    Unregister-CardanoNodePath -Network $Network
    
    Unregister-CardanoNodeSocketPath -Network $Network
    
    Unregister-CardanoNodeProtocolParameters -Network $Network

    Assert-CardanoNodeStopped -Network $Network

    Write-VerboseLog 'Cardano node stopped'
}
