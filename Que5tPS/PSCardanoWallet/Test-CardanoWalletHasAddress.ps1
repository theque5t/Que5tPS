function Test-CardanoWalletHasAddress {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $addresses = Get-CardanoWalletAddresses -Wallet $Wallet
    return [bool]$addresses.Count
}
