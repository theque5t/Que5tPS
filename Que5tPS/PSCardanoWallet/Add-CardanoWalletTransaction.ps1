function Add-CardanoWalletTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $network = Get-CardanoWalletNetwork -Wallet $Wallet
    Assert-CardanoNodeInSync -Network $network
    $transaction = New-CardanoTransaction `
        -WorkingDir $(Get-CardanoWalletTransactionsDirectory -Wallet $Wallet) `
        -Name $Name `
        -Network $network
    return $transaction
}
