function Test-CardanoWalletHasTokens {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $tokens = Get-CardanoWalletTokens -Wallet $Wallet
    return [bool]$tokens.Count
}
