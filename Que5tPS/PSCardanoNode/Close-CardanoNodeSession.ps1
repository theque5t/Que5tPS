function Close-CardanoNodeSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Assert-CardanoNodeSessionIsOpen -Network $Network

    Write-VerboseLog 'Closing Cardano node session...'

    Stop-CardanoNode -Network $Network
    
    Unregister-CardanoNodeSession -Network $Network
    
    Assert-CardanoNodeSessionIsClosed -Network $Network

    Write-VerboseLog 'Cardano node session closed'
}
