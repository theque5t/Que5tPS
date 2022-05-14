function Update-CardanoMintContractTokenImplementation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [int64]$MintedDifference = 0,
        [int64]$BurnedDifference = 0,
        [bool]$UpdateState = $true
    )
    $minted = Get-CardanoMintContractTokenImplementationMinted `
        -MintContract $MintContract `
        -Name $Name
    $burned = Get-CardanoMintContractTokenImplementationBurned `
        -MintContract $MintContract `
        -Name $Name

    Set-CardanoMintContractTokenImplementation `
        -MintContract $MintContract `
        -Name $Name `
        -Minted $($minted + $MintedDifference) `
        -Burned $($burned + $BurnedDifference)
}
