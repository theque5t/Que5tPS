function Get-CardanoWalletStateFileContent {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [switch]$Colored
    )
    $stateFileContent = $Wallet.StateFileContent
    if($Colored){
        $stateFileContent = Format-ColoredString `
            -String $stateFileContent `
            -Pattern '[a-zA-Z]+:' `
            -ForegroundColor 'Blue'
    }
    return $stateFileContent
}
