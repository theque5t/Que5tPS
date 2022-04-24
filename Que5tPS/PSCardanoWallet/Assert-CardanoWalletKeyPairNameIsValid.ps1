function Assert-CardanoWalletKeyPairNameIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    if(-not $(Test-CardanoWalletKeyPairNameIsValid -Wallet $Wallet -Name $Name)){
        Write-FalseAssertionError
    }
}
