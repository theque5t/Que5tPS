function Assert-CardanoNodeInstalled {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Deadalus')]
        $NodeType
    )
    if(-not $(Test-CardanoNodeInstalled -Network $Network -NodeType $NodeType)){
        Write-FalseAssertionError
    }
}
