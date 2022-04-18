function Close-CardanoWalletSession {
    [CmdletBinding()]
    param()
    Assert-CardanoWalletSessionIsOpen
    $wallets = Get-CardanoWalletSessionWallets
    $wallets.ForEach({
        Assert-CardanoWalletInSession -Wallet $_
        Remove-CardanoWalletSessionWallet -Wallet $_
        Assert-CardanoWalletNotInSession -Wallet $_
    })
    Unregister-CardanoWalletSession
    Assert-CardanoWalletSessionIsClosed
}
