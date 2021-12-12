function Assert-CardanoNodeSessionIsOpen {
    if(-not $(Test-CardanoNodeSessionIsOpen)){
        Write-FalseAssertionError
    }
}
