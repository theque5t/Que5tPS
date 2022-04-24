function Assert-CardanoWalletAddressNameIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    if(-not $(Test-CardanoWalletAddressNameIsValid -Wallet $Wallet -Name $Name)){
        Write-FalseAssertionError
    }
}
