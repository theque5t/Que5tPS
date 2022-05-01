function Get-CardanoWalletTokens {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $utxos = Get-CardanoWalletUtxos -Wallet $Wallet
    $tokens = Merge-CardanoTokens -Tokens $utxos.Value
    return $tokens
}
