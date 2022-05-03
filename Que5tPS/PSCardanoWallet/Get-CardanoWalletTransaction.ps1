function Get-CardanoWalletTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $transactions = Get-CardanoWalletTransactions -Wallet $Wallet
    $transaction = $transactions.Where({
        $_.Name -eq $Name
    })
    return $transaction
}
