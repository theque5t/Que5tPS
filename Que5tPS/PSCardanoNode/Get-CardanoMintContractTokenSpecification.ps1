function Get-CardanoMintContractTokenSpecification {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $tokenSpecifications = Get-CardanoMintContractTokenSpecifications `
        -MintContract $MintContract
    $tokenSpecification = $tokenSpecifications.Where({
        $_.Name -eq $Name
    })
    return $tokenSpecification
}
