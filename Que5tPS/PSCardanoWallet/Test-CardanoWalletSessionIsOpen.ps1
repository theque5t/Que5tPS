function Test-CardanoWalletSessionIsOpen {
    return Test-Path env:CARDANO_WALLET_SESSION
}
