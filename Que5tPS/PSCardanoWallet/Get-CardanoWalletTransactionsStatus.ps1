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
            TotalRecieved = 'TODO'
            TotalSent = $(Get-CardanoWalletSubmittedTransactions -Wallet $_ | Measure-Object -Sum).Sum
        }
    })
    return $walletTransactionsStatus
}
