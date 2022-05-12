function Update-CardanoMintContract {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    Update-CardanoMintContractState -MintContract $MintContract
    Update-CardanoMintContractPolicy -MintContract $MintContract
}
