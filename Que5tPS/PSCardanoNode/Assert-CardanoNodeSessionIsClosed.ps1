function Assert-CardanoNodeSessionIsClosed {
    if($(Test-CardanoNodeSessionIsOpen)){
        Write-FalseAssertionError
    }
}
