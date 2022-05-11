function Set-CardanoMintContractNetwork {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [bool]$UpdateState = $true
    )
    $MintContract.Network = $Network
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
