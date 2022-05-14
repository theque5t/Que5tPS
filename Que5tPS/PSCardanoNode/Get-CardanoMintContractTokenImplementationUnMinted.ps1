function Get-CardanoMintContractTokenImplementationUnMinted {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $supplyLimit = Get-CardanoMintContractTokenSpecificationSupplyLimit `
        -MintContract $MintContract `
        -Name $Name
    $supply = Get-CardanoMintContractTokenImplementationSupply `
        -MintContract $MintContract `
        -Name $Name
    $unminted = $supplyLimit - $supply
    return $unminted
}
