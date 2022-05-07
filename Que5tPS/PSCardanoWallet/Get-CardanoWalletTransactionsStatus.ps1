function Get-CardanoWalletTransactionsStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $walletTransactionsStatus = @()
    $Wallets.ForEach({
        $walletTransactionsStatus += [PSCustomObject]@{
            Wallet = Get-CardanoWalletName -Wallet $_
            # Depends on wallet provider. If using cardano-cli, there is no native function to query for transactions by address.
            # Thus would probably have to use a 3rd party api, like Blockfrost.
            # However, if using cardano-wallet, there is a native function to list transactions associated to wallet by date range.
            TotalInbound = 'Unknown. Not available on CardanoCLI provider. See documentation.'
            TotalOutbound = $(Get-CardanoWalletSubmittedTransactions -Wallet $_).Count
        }
    })
    return $walletTransactionsStatus
}
