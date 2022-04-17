function Get-CardanoWalletSessionPaths {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $walletSessionPath = $env:CARDANO_WALLET_SESSION_PATH -split ';'
    return $walletSessionPath
}
