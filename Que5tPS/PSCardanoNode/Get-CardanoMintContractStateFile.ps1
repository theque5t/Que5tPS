function Get-CardanoMintContractStateFile {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return $MintContract.StateFile
}
