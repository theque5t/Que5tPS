function Get-CardanoWalletSessionPaths {
    [CmdletBinding()]
    param()
    $walletSessionPaths = $env:CARDANO_WALLET_SESSION_PATHS -split ';'
    return $walletSessionPaths
}
