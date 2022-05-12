function Remove-CardanoMintContractTokenSpecification {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [bool]$UpdateState = $true
    )
    $MintContract.TokenSpecifications = $MintContract.TokenSpecifications.Where({
        $_.Name -ne $Name
    })
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
