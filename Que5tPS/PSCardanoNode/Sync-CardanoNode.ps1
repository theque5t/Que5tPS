function Sync-CardanoNode {
    [CmdletBinding()]
    param()
    Assert-CardanoNodeSessionIsOpen

    do{
        Write-VerboseLog "Sync percentage: $($(Get-CardanoNodeTip).syncProgress)"
        Start-Sleep -Seconds 5
    }
    while(-not $(Test-CardanoNodeInSync))
}
