function Assert-CardanoWalletInSession {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    if(-not $(Test-CardanoWalletSessionInSession -Wallet $Wallet)){
        Write-FalseAssertionError
    }
}
