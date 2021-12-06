function Assert-CardanoWalletDoesNotExist {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    if($(Test-CardanoWalletExists $Name)){
        Write-FalseAssertionError
    }
}
