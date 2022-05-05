function Get-CardanoWalletTokensStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $walletTokensStatus = @()
    $Wallets.ForEach({
        $walletTokensStatus += [PSCustomObject]@{
            Wallet = Get-CardanoWalletName -Wallet $_
            LovelaceTokens = $(Get-CardanoWalletToken -Wallet $_ -PolicyId '' -Name 'lovelace').Quantity
            OtherTokens = $($(Get-CardanoWalletTokens -Wallet $_ -Filter 'Exclude' -PolicyId '' -Name 'lovelace').Quantity | Measure-Object -Sum).Sum
            UnMinted = 'TODO'
            Minted = 'TODO'
        }
    })
    return $walletTokensStatus
}
