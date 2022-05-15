function Assert-CardanoMintContractDirectoryDoesNotExist {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    if($(Test-CardanoMintContractDirectoryExists -MintContract $MintContract)){
        Write-FalseAssertionError
    }
}
