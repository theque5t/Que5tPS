function Get-CardanoMintContractTokenImplementation {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $tokenImplementations = Get-CardanoMintContractTokenImplementations `
        -MintContract $MintContract
    $tokenImplementation = $tokenImplementations.Where({
        $_.Name -eq $Name
    })
    return $tokenImplementation
}
