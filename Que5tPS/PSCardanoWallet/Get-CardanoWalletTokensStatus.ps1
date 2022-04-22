function Get-CardanoWalletTokensStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    # Tokens High-level
    #           Lovelace | Other Tokens | Un-minted | Minted | Most Recent | Last Updated
    # wallet1 | 1000     | 5
    # wallet2 | 200      | 10

    $walletTokensStatus = @()
    $Wallets.ForEach({
        $walletTokensStatus += [PSCustomObject]@{
            Wallet = Get-CardanoWalletName -Wallet $_
            LovelaceTokens = 0 #$(Get-CardanoWalletTokens -Wallet $_ -Include @{ Policy = ''; Name = 'lovelace' }).Quantity
            OtherTokens = 0 #$($(Get-CardanoWalletTokens -Wallet $_ -Exclude @{ Policy = ''; Name = 'lovelace' }).Quantity | Measure-Object -Sum).Sum
            UnMinted = 0 #$($(Get-CardanoWalletUnmintedTokens -Wallet $_).Quantity | Measure-Object -Sum).Sum
            Minted = 0 #$($(Get-CardanoWalletMintedTokens -Wallet $_).Quantity | Measure-Object -Sum).Sum
            MostRecent = $null
            LastUpdated = $null
        }
    })
    return $walletTokensStatus
}
