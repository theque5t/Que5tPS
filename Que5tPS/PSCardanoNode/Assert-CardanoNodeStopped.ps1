function Assert-CardanoNodeStopped {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    if($(Test-CardanoNodeIsStarted -Network $Network)){
        Write-FalseAssertionError
    }
}
