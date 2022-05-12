function Set-CardanoMintContractTokenSpecification {
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
    Remove-CardanoMintContractTokenSpecification `
        -MintContract $MintContract `
        -Name $Name `
        -UpdateState $False

    Add-CardanoMintContractTokenSpecification `
        -MintContract $MintContract `
        -Name $Name `
        -SupplyLimit $SupplyLimit `
        -MetaData $MetaData `
        -UpdateState $False

    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}