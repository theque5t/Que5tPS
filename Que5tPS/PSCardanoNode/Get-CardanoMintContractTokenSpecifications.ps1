function Get-CardanoMintContractTokenSpecifications {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.TokenSpecifications
}
