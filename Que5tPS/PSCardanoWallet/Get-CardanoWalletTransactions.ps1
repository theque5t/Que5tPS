function Get-CardanoWalletTransactions {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $transactionStateFiles = Get-ChildItem `
        -Path $(Get-CardanoWalletTransactionsDirectory -Wallet $Wallet) `
        -File state.yaml
        -Recurse
    $transactions = [CardanoTransaction[]]@()
    $transactionStateFiles.ForEach({
        $transactions += Import-CardanoTransaction `
            -StateFile $_
    })
    return $transactions
}
