function Test-CardanoNodeIsStarted {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $isRunning = Test-CardanoNodeIsRunning -Network $Network
    $isResponding = Test-CardanoNodeIsResponding -Network $Network
    $result = $isRunning -and $isResponding
    return $result
}
