function Test-CardanoNodeInSync {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    return $(Get-CardanoNodeTip -Network $Network).syncProgress -eq '100.00'
}
