function Test-CardanoWalletKeyPairNameExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $keypairs = Get-CardanoWalletKeyPairs -Wallet $Wallet
    return $Name -in $keyPairs.Name
}
