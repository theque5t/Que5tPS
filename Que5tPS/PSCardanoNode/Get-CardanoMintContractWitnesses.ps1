function Get-CardanoMintContractWitnesses {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.Witnesses
}
