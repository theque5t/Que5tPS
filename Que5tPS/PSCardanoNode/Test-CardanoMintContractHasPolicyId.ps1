function Test-CardanoMintContractHasPolicyId {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return [bool]$(Get-CardanoMintContractPolicyId -MintContract $MintContract)
}
