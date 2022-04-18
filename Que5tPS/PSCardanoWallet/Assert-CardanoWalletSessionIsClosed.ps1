function Assert-CardanoWalletSessionIsClosed {
    [CmdletBinding()]
    param()
    if($(Test-CardanoWalletSessionIsOpen)){
        Write-FalseAssertionError
    }
}
