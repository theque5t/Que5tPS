function Test-CardanoWalletExists {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    return $null -ne $(Get-CardanoWallet $Name)
}
