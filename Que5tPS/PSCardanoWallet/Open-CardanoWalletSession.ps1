function Open-CardanoWalletSession {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $Wallets.ForEach({
        Assert-CardanoWalletSessionIsClosed -Wallet $Wallet
        Assert-CardanoNodeInSync -Network $Wallet.Network
        Add-CardanoWalletSessionWallet -Wallet $Wallet
        Assert-CardanoWalletSessionIsOpen -Wallet $Wallet
    })
}
