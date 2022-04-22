function Get-CardanoWalletTransactionsStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    # Transactions High-level
    #           Un-Submitted | Submitted | Most Recent | Last Updated    | Total Recieved | Total Sent
    # wallet1 | 1000         | 5         | tx3         | 4/19/2022 21:22 | TBD/Nice2Have  | TBD/Nice2Have
    # wallet2 | 200          | 10        | tx3         | 4/19/2022 21:22 | TBD/Nice2Have  | TBD/Nice2Have

    $walletTransactionsStatus = @()
    $Wallets.ForEach({
        $walletTransactionsStatus += [PSCustomObject]@{
            Wallet = Get-CardanoWalletName -Wallet $_
            UnSubmitted = 0 #$(Get-CardanoWalletTokens -Wallet $_ -Include @{ Policy = ''; Name = 'lovelace' }).Quantity
            Submitted = 0 #$($(Get-CardanoWalletTokens -Wallet $_ -Exclude @{ Policy = ''; Name = 'lovelace' }).Quantity | Measure-Object -Sum).Sum
            MostRecent = $null #$($(Get-CardanoWalletUnmintedTokens -Wallet $_).Quantity | Measure-Object -Sum).Sum
            LastUpdated = $null #$($(Get-CardanoWalletMintedTokens -Wallet $_).Quantity | Measure-Object -Sum).Sum
            TotalRecieved = 0
            TotalSent = 0
        }
    })
    return $walletTransactionsStatus
}
