function Get-CardanoMintContractPolicyFile {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.PolicyFile
}
