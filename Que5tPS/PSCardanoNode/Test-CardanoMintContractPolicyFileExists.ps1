function Test-CardanoMintContractPolicyFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $policyFile = Get-CardanoMintContractPolicyFile -MintContract $MintContract
    return Test-Path $policyFile
}
