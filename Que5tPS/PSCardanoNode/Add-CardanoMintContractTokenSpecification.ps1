function Add-CardanoMintContractTokenSpecification {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [int64]$SupplyLimit,
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        $MetaData,
        [bool]$UpdateState = $true
    )
    $MintContract.TokenSpecifications += New-CardanoTokenSpecification `
        -Name $Name `
        -SupplyLimit $SupplyLimit `
        -MetaData $MetaData
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
