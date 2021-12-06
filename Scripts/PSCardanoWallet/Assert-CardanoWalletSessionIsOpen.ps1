function Assert-CardanoWalletSessionIsOpen {
    if(-not $(Test-CardanoWalletSessionIsOpen)){
        Write-FalseAssertionError
    }
}
