function Assert-CardanoMintContractTimeLockIsValid {
    param(
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [int64]$AfterSlot,
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [int64]$BeforeSlot
    )
    if(-not $(Test-CardanoMintContractTimeLockIsValid -AfterSlot $AfterSlot -BeforeSlot $BeforeSlot)){
        Write-FalseAssertionError
    }
}
