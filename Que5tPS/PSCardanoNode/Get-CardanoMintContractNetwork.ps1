function Get-CardanoMintContractNetwork {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.Network
}
