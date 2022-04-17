function Wait-CardanoNodeResponding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    while(-not $(Test-CardanoNodeIsResponding -Network $Network)){
        Write-VerboseLog 'Waiting for Cardano node to respond...'
        Start-Sleep -Seconds 5
    }
}
