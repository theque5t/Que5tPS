function Get-CardanoMintContractTokenImplementationMinted {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $tokenImplementation = Get-CardanoMintContractTokenImplementation `
        -MintContract $MintContract `
        -Name $Name
    return $tokenImplementation.Minted
}
