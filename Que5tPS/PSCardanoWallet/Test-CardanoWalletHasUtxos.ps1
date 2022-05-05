function Test-CardanoWalletHasUtxos {
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $utxos = Get-CardanoWalletUtxos -Wallet $Wallet
    return [bool]$utxos.Count
}
