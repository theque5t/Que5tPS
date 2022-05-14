function Get-CardanoMintContractTokenImplementations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.TokenImplementations
}
