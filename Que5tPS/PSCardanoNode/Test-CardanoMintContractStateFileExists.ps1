function Test-CardanoMintContractStateFileExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $stateFile = Get-CardanoMintContractStateFile -MintContract $MintContract
    return Test-Path $stateFile
}
