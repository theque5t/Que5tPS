function Open-CardanoNodeSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Deadalus')]
        $NodeType
    )
    Assert-CardanoNodeSessionIsClosed -Network $Network

    Write-VerboseLog 'Opening Cardano node session...'
    
    Start-CardanoNode -Network $Network -NodeType $NodeType

    Register-CardanoNodeSession -Network $Network

    Assert-CardanoNodeSessionIsOpen -Network $Network

    Write-VerboseLog 'Cardano node session opened'
}
