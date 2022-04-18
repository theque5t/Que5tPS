function Set-CardanoWalletName {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [bool]$UpdateState = $true
    )
    $Wallet.Name = $Name
    if($UpdateState){
        Update-CardanoWallet -Wallet $Wallet
    }
}
