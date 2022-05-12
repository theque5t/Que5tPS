function Import-CardanoMintContractPolicy {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $network = Get-CardanoMintContractNetwork -MintContract $MintContract
    Assert-CardanoNodeSessionIsOpen -Network $network
    Assert-CardanoMintContractPolicyFileExists -MintContract $MintContract
    $MintContract.PolicyFile = Get-Item $MintContract.PolicyFile
    $MintContract.PolicyFileContent = Get-Content $MintContract.PolicyFile
    $MintContract.PolicyFileObject = if($MintContract.PolicyFileContent){ 
        $MintContract.PolicyFileContent | ConvertFrom-Json  
    }
    $MintContract.PolicyId = if($MintContract.PolicyFileObject.scripts.Count){ 
        $socket = Get-CardanoNodeSocket -Network $network
        $nodePath = Get-CardanoNodePath -Network $network
        $_args = @(
            'transaction', 'policyid'
            '--script-file', $MintContract.PolicyFile
        )
        Invoke-CardanoCLI `
            -Socket $socket `
            -Path $nodePath `
            -Arguments $_args
    }
}
