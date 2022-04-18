function Open-CardanoWalletSession {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    Assert-CardanoWalletSessionIsClosed
    $Wallets.ForEach({
        Assert-CardanoWalletNotInSession -Wallet $_
        Assert-CardanoNodeInSync -Network $_.Network
        Add-CardanoWalletSessionWallet -Wallet $_
        Assert-CardanoWalletInSession -Wallet $_
    })
    Register-CardanoWalletSession
    Assert-CardanoWalletSessionIsOpen
}
