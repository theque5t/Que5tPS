function Export-CardanoMintContractState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $stateFile = Get-CardanoMintContractStateFile -MintContract $MintContract
    [ordered]@{
        Name = Get-CardanoMintContractName -MintContract $MintContract 
        Description = Get-CardanoMintContractDescription -MintContract $MintContract 
        Network = Get-CardanoMintContractNetwork -MintContract $MintContract
        Witnesses = Get-CardanoMintContractWitnesses -MintContract $MintContract
    } | ConvertTo-Yaml -Options EmitDefaults -OutFile $stateFile -Force    
}
