function Assert-CardanoNodeInSync {
    Assert-CardanoNodeSessionIsOpen
    if(-not $(Test-CardanoNodeInSync)){
        Write-FalseAssertionError
    }
}
