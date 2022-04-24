function Set-CardanoWalletDescription {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory=$true)]
        [string]$Description,
        [bool]$UpdateState = $true
    )
    $Wallet.Description = $Description
    if($UpdateState){
        Update-CardanoWallet -Wallet $Wallet
    }
}
