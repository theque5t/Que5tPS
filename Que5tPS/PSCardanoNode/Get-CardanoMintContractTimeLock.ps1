function Get-CardanoMintContractTimeLock {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    return [PSCustomObject]@{
        AfterSlot = $MintContract.TimeLockAfterSlot
        BeforeSlot = $MintContract.TimeLockBeforeSlot
    }
}
