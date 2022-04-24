function Assert-CardanoWalletKeyPairNameExists {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    if(-not $(Test-CardanoWalletKeyPairNameExists -Wallet $Wallet -Name $Name)){
        Write-FalseAssertionError
    }
}
