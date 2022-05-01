function Get-CardanoWalletUtxos {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $network = Get-CardanoWalletNetwork -Wallet $Wallet
    Assert-CardanoNodeInSync -Network $network
    $addresses = $(Get-CardanoWalletAddresses -Wallet $Wallet).Hash
    $workingDir = Get-CardanoWalletWorkingDirectory -Wallet $Wallet
    $utxos = Get-CardanoAddressesUtxos `
        -Network $network `
        -Addresses $addresses `
        -WorkingDir $workingDir
    return $utxos
}
