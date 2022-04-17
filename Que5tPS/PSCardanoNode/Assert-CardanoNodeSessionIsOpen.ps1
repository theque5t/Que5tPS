function Assert-CardanoNodeSessionIsOpen {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    if(-not $(Test-CardanoNodeSessionIsOpen -Network $Network)){
        Write-FalseAssertionError
    }
}
