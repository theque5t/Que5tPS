function Add-CardanoMintContractTokenImplementation {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [int64]$Minted,
        [Parameter(Mandatory = $true)]
        [int64]$Burned,
        [bool]$UpdateState = $true
    )
    $MintContract.TokenImplementations += New-CardanoTokenImplementation `
        -Name $Name `
        -Minted $Minted `
        -Burned $Burned
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
