function Assert-CardanoWalletSessionIsOpen {
    [CmdletBinding()]
    param()
    if(-not $(Test-CardanoWalletSessionIsOpen)){
        Write-FalseAssertionError
    }
}
