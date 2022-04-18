function Export-CardanoWalletState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    [ordered]@{
        Name = Get-CardanoWalletName -Wallet $Wallet 
        Network = Get-CardanoWalletNetwork -Wallet $Wallet
    } | ConvertTo-Yaml -Options EmitDefaults -OutFile $Wallet.StateFile -Force
}
