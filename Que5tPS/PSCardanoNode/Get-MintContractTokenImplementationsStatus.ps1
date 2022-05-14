function Get-MintContractTokenImplementationsStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $tokenImplementationsStatus = @()
    $tokenImplementations = Get-CardanoMintContractTokenImplementations `
        -MintContract $MintContract
    $tokenImplementations.ForEach({
        $_params = @{ MintContract = $MintContract; Name = $_.Name }
        $tokenImplementationsStatus += [PSCustomObject]@{
            Name = $_.Name
            Supply = Get-MintContractTokenImplementationSupply @_params
            UnMinted = Get-MintContractTokenImplementationUnMinted @_params
            Minted = Get-MintContractTokenImplementationMinted @_params
            Burned = Get-MintContractTokenImplementationBurned @_params
        }
    })
    return $tokenImplementationsStatus
}
