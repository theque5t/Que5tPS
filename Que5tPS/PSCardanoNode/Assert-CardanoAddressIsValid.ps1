function Assert-CardanoAddressIsValid {
    param(
        [Parameter(Mandatory=$true)]
        $Address
    )
    if(-not $(Test-CardanoAddressIsValid $Address)){
        Write-FalseAssertionError
    }
}
