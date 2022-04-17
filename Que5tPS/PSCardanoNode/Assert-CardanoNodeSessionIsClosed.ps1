function Assert-CardanoNodeSessionIsClosed {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    if($(Test-CardanoNodeSessionIsOpen -Network $Network)){
        Write-FalseAssertionError
    }
}
