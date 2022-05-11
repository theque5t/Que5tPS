function Get-CardanoMintContractPolicy {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.Policy
}
