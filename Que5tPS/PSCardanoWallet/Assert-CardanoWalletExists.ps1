function Assert-CardanoWalletExists {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    if(-not $(Test-CardanoWalletExists $Name)){
        Write-FalseAssertionError
    }
}
