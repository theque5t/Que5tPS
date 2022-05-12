function Get-CardanoMintContractPolicyId {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.PolicyId
}
