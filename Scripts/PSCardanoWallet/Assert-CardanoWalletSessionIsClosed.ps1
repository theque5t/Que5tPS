function Assert-CardanoWalletSessionIsClosed {
    if($(Test-CardanoWalletSessionIsOpen)){
        Write-FalseAssertionError
    }
}
