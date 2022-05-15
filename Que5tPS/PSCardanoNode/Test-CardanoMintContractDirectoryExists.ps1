function Test-CardanoMintContractDirectoryExists {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    $MintContractDir = Get-CardanoMintContractDirectory -MintContract $MintContract
    return Test-Path $MintContractDir
}
