function Test-CardanoWalletHasKeyPair {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $keypairs = Get-CardanoWalletKeyPairs -Wallet $Wallet
    return [bool]$keypairs.Count
}
