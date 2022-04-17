function Assert-CardanoNodeStarted {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    if(-not $(Test-CardanoNodeIsStarted -Network $Network)){
        Write-FalseAssertionError
    }
}
