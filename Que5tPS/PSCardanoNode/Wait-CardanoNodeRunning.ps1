function Wait-CardanoNodeRunning {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    while(-not $(Test-CardanoNodeIsRunning -Network $Network)){
        Write-VerboseLog 'Waiting for Cardano node to start running...'
        Start-Sleep -Seconds 5
    }
}
