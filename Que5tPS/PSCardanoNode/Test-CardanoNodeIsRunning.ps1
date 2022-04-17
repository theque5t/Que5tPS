function Test-CardanoNodeIsRunning {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $process = Get-CardanoNodeProcess -Network $Network
    return $process.Count -gt 0
}
