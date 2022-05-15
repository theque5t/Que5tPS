function Test-CardanoMintContractHasTokenImplementations {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return [bool]$(Get-CardanoMintContractTokenImplementations -MintContract $MintContract).Count
}
