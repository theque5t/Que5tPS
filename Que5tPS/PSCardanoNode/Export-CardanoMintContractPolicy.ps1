function Export-CardanoMintContractPolicy {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $policyFile = Get-CardanoMintContractPolicyFile -MintContract $MintContract
    $policy = @{
        scripts = @()
        type = 'all'
    }
    
    $witnesses = Get-CardanoMintContractWitnesses -MintContract $MintContract
    $witnesses.ForEach({
        $policy.scripts += @{ keyHash = $_; type = 'sig' }
    })

    $timelock = Get-CardanoMintContractTimeLock -MintContract $MintContract
    if($timelock.AfterSlot){
        $policy.scripts += @{ slot = $timelock.AfterSlot; type = 'after' }
    }
    if($timelock.BeforeSlot){
        $policy.scripts += @{ slot = $timelock.BeforeSlot; type = 'before' }
    }
    
    $policy | ConvertTo-Json | Out-File -FilePath $policyFile -Force    
}
