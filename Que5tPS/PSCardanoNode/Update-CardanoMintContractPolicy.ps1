function Update-CardanoMintContractPolicy {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    Export-CardanoMintContractPolicy -MintContract $MintContract
    Import-CardanoMintContractPolicy -MintContract $MintContract
}
