function Assert-CardanoWalletSigningKeyFileDoesNotExist {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    if($(Test-CardanoWalletSigningKeyFileExists $Name)){
        Write-FalseAssertionError
    }
}
