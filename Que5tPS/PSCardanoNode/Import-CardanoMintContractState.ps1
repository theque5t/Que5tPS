function Import-CardanoMintContractState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    Assert-CardanoMintContractStateFileExists -MintContract $MintContract
    $MintContract.StateFile = Get-Item $MintContract.StateFile
    $MintContract.StateFileContent = Get-Content $MintContract.StateFile
    if($MintContract.StateFileContent){
        $state = Get-Content $MintContract.StateFile | ConvertFrom-Yaml

        Set-CardanoMintContractName `
            -MintContract $MintContract `
            -Name $state.Name `
            -UpdateState $False
        
        Set-CardanoMintContractDescription `
            -MintContract $MintContract `
            -Description $state.Description `
            -UpdateState $False

        Set-CardanoMintContractNetwork `
            -MintContract $MintContract `
            -Network $state.Network `
            -UpdateState $False
        
        Set-CardanoMintContractWitnesses `
            -MintContract $MintContract `
            -Witnesses $state.Witnesses `
            -UpdateState $False
    }
}
