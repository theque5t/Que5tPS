function Clear-CardanoWalletUnsubmittedTransactions {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $Wallets.ForEach({
        $wallet = $_
        $(Get-CardanoWalletUnsubmittedTransactions -Wallet $wallet).ForEach({
            $transactionName = Get-CardanoTransactionName -Transaction $_
            Remove-CardanoWalletTransaction `
                -Wallet $wallet `
                -Name $transactionName
        })
    })
}
