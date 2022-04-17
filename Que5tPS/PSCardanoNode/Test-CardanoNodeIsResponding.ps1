function Test-CardanoNodeIsResponding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $response = Get-CardanoNodeTip -Network $Network
    return [bool]$response
}
