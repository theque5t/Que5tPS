function Assert-CardanoWalletSessionIsOpen {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    if(-not $(Test-CardanoWalletSessionIsOpen -Wallet $Wallet)){
        Write-FalseAssertionError
    }
}
