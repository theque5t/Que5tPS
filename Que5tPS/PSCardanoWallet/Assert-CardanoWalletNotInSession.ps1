function Assert-CardanoWalletNotInSession {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    if($(Test-CardanoWalletSessionInSession -Wallet $Wallet)){
        Write-FalseAssertionError
    }
}
