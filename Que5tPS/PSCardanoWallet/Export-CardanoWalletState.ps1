function Export-CardanoWalletState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    [ordered]@{
        Name = Get-CardanoWalletName -Wallet $Wallet 
        Description = Get-CardanoWalletDescription -Wallet $Wallet 
        Network = Get-CardanoWalletNetwork -Wallet $Wallet
        KeyPairs = Get-CardanoWalletKeyPairs -Wallet $Wallet
        Addresses = Get-CardanoWalletAddresses -Wallet $Wallet
    } | ConvertTo-Yaml -Options EmitDefaults -OutFile $Wallet.StateFile -Force
}
