function Get-MintContractPolicy {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $policyId = Get-CardanoMintContractPolicyId -MintContract $MintContract
    $policyScript = Get-CardanoMintContractPolicyScript -MintContract $MintContract
    $policy = New-CardanoPolicy `
        -Id $policyId `
        -Script $policyScript
    return $policy
}
