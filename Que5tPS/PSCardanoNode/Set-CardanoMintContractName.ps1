function Set-CardanoMintContractName {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [bool]$UpdateState = $true
    )
    $MintContract.Name = $Name
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
