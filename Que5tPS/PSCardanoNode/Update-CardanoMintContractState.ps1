function Update-CardanoMintContractState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    Export-CardanoMintContractState -MintContract $MintContract
    Import-CardanoMintContractState -MintContract $MintContract
}
