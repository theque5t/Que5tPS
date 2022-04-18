function Unregister-CardanoWalletSession {
    [CmdletBinding()]
    param()
    Remove-Item 'env:CARDANO_WALLET_SESSION'
}
