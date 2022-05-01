function Get-CardanoWalletTransactionsDirectory {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    return $Wallet.TransactionsDir
}
