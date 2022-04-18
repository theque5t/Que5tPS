function Test-CardanoWalletSessionIsOpen {
    [CmdletBinding()]
    param()
    return Test-Path env:CARDANO_WALLET_SESSION
}
