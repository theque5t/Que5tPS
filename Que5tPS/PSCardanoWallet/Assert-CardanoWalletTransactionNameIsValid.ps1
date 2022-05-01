function Assert-CardanoWalletTransactionNameIsValid {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    if(-not $(Test-CardanoWalletTransactionNameIsValid -Wallet $Wallet -Name $Name)){
        Write-FalseAssertionError
    }
}
