function Test-CardanoWalletSigningKeyFileExists {
    param(
        $Name
    )
    $null -ne $(Get-CardanoWalletKeyFile $Name -Type signing)
}
