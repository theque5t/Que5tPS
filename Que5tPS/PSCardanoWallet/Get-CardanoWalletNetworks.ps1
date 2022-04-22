function Get-CardanoWalletNetworks {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $walletNetworks = @()
    $Wallets.ForEach({
        $walletNetworks += Get-CardanoWalletNetwork -Wallet $_
    })
    return $walletNetworks
}
