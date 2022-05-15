function Assert-CardanoMintContractStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    if(-not $(Test-CardanoMintContractStateFileExists -MintContract $MintContract)){
        Write-FalseAssertionError
    }
}
