function Assert-CardanoMintContractPolicyFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    if(-not $(Test-CardanoMintContractPolicyFileExists -MintContract $MintContract)){
        Write-FalseAssertionError
    }
}
