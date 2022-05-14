function Get-CardanoMintContractTokenImplementationSupply {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $minted = Get-CardanoMintContractTokenImplementationMinted `
        -MintContract $MintContract `
        -Name $Name
    $burned = Get-CardanoMintContractTokenImplementationBurned `
        -MintContract $MintContract `
        -Name $Name
    $supply = $minted - $burned
    return $supply
}
