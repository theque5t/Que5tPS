function Get-CardanoWalletSessionWallets {
    [CmdletBinding()]
    param()
    $walletSessionPaths = Get-CardanoWalletSessionPaths
    $wallets = [CardanoWallet[]]@()
    $walletSessionPaths.ForEach({
        $wallets += Import-CardanoWallet -StateFile $_
    })
    return $wallets
}
