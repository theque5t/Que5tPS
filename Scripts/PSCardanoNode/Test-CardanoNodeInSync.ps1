function Test-CardanoNodeInSync {
    return $(Get-CardanoNodeTip).syncProgress -eq '100.00'
}
