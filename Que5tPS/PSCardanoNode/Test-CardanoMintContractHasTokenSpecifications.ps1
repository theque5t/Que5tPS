function Test-CardanoMintContractHasTokenSpecifications {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return [bool]$(Get-CardanoMintContractTokenSpecifications -MintContract $MintContract).Count
}
