function Get-CardanoMintContractDirectory {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.MintContractDir
}
