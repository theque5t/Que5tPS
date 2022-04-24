function Test-CardanoWalletAddressNameExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $addresses = Get-CardanoWalletAddresses -Wallet $Wallet
    return $Name -in $addresses.Name
}
