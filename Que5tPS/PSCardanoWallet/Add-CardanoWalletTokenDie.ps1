function Add-CardanoWalletTokenDie {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
        #TODO
    )
    $tokenDie = New-CardanoTokenDie `
        -TODO
    return $tokenDie
}
