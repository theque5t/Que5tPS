function Get-MintContractTokenSpecifications {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.TokenSpecifications
}
