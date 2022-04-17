function Sync-CardanoNode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    Assert-CardanoNodeSessionIsOpen -Network $Network
    Write-VerboseLog "Sync percentage: $($(Get-CardanoNodeTip -Network $Network).syncProgress)"
    while(-not $(Test-CardanoNodeInSync -Network $Network)){
        Start-Sleep -Seconds 5
        Write-VerboseLog "Sync percentage: $($(Get-CardanoNodeTip -Network $Network).syncProgress)"
    }
}
