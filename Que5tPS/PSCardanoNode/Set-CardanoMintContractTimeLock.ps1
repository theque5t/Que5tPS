function Set-CardanoMintContractTimeLock {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [int64]$AfterSlot,
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [int64]$BeforeSlot,
        [bool]$UpdateState = $true
    )
    Assert-CardanoMintContractTimeLockIsValid `
        -AfterSlot $AfterSlot `
        -BeforeSlot $BeforeSlot

    $MintContract.TimeLockAfterSlot = $AfterSlot
    $MintContract.TimeLockBeforeSlot = $BeforeSlot
    
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
