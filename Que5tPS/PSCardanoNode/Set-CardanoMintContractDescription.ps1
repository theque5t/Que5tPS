function Set-CardanoMintContractDescription {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory=$true)]
        [string]$Description,
        [bool]$UpdateState = $true
    )
    $MintContract.Description = $Description
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
