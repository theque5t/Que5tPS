function Set-CardanoWalletNetwork {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [bool]$UpdateState = $true
    )
    $Wallet.Network = $Network
    if($UpdateState){
        Update-CardanoWallet -Wallet $Wallet
    }
}
