function Remove-CardanoWalletTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $transaction = Get-CardanoWalletTransaction -Wallet $Wallet -Name $Name
    Remove-CardanoTransactionDirectory -Transaction $transaction
}
