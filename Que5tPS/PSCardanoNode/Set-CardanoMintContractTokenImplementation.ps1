function Set-CardanoMintContractTokenImplementation {
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
    Remove-CardanoMintContractTokenImplementation `
        -MintContract $MintContract `
        -Name $Name `
        -UpdateState $False

    Add-CardanoMintContractTokenImplementation `
        -MintContract $MintContract `
        -Name $Name `
        -Minted $Minted `
        -Burned $Burned `
        -UpdateState $False

    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
