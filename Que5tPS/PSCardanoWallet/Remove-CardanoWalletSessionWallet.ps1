function Remove-CardanoWalletSessionWallet {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $walletSessionPaths = Get-CardanoWalletSessionPaths
    $env:CARDANO_WALLET_SESSION_PATHS = $($walletSessionPaths.Where({ 
        $_ -ne $Wallet.StateFile
    })) -join ';'
}
