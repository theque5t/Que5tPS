function Remove-CardanoMintContractTokenImplementation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [bool]$UpdateState = $true
    )
    $MintContract.TokenImplementations = $MintContract.TokenImplementations.Where({
        $_.Name -ne $Name
    })
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}