function Import-CardanoWalletState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    Assert-CardanoWalletStateFileExists -Wallet $Wallet
    $Wallet.StateFile = Get-Item $Wallet.StateFile
    $Wallet.StateFileContent = Get-Content $Wallet.StateFile
    if($Wallet.StateFileContent){
        $state = Get-Content $Wallet.StateFile | ConvertFrom-Yaml
        Set-CardanoWalletNetwork `
            -Wallet $Wallet `
            -Network $state.Network `
            -UpdateState $False
    }
}
