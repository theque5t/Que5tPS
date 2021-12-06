function Remove-CardanoWalletSigningKeyFile {
    param(
        $Name
    )
    if($(Test-CardanoWalletSigningKeyFileExists $Name)){
        $signingKey = Get-CardanoWalletKeyFile $Name -Type signing
        Remove-Item $signingKey
    }
    Assert-CardanoWalletSigningKeyFileDoesNotExist $Name
}
