function Get-MintContractTokenImplementations {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.TokenImplementations
}
