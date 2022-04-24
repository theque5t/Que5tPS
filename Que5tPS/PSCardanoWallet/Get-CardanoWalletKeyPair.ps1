function Get-CardanoWalletKeyPair {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $keyPairs = Get-CardanoWalletKeyPairs -Wallet $Wallet
    $keyPair = $keyPairs.Where({ $_.Name -eq $Name })
    return $keyPair
}
