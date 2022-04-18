function Enter-CardanoWalletSession {
    [CmdletBinding()]
    param()
    Assert-CardanoWalletSessionIsOpen
    $wallets = Get-CardanoWalletSessionWallets
    # TODO: The meat and potatos
    return $wallets
}
