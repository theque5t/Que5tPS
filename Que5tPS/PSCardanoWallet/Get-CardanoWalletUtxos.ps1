function Get-CardanoWalletUtxos {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $network = Get-CardanoWalletNetwork -Wallet $Wallet
    Assert-CardanoNodeInSync -Network $network
    $addresses = $(Get-CardanoWalletAddresses -Wallet $Wallet).Hash
    $walletDir = Get-CardanoWalletDirectory -Wallet $Wallet
    $utxos = Get-CardanoAddressesUtxos `
        -Network $network `
        -Addresses $addresses `
        -WorkingDir $walletDir
    return $utxos
}
