function Export-CardanoWalletState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    [ordered]@{ 
        Network = Get-CardanoWalletNetwork -Wallet $Wallet
    } | ConvertTo-Yaml -Options EmitDefaults -OutFile $Wallet.StateFile -Force
}
