function Assert-CardanoNodeInSync {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Assert-CardanoNodeSessionIsOpen -Network $Network
    if(-not $(Test-CardanoNodeInSync -Network $Network)){
        Write-FalseAssertionError
    }
}
