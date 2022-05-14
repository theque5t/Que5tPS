function Get-CardanoMintContractTokenSpecificationSupplyLimit {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $tokenSpecification = Get-CardanoMintContractTokenSpecification `
        -MintContract $MintContract `
        -Name $Name
    return $tokenSpecification.SupplyLimit
}
