function Get-CardanoMintContractPolicyScript {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.PolicyFileObject
}
