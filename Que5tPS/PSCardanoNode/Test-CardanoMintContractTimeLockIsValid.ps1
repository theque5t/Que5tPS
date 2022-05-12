function Test-CardanoMintContractTimeLockIsValid {
    param(
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [int64]$AfterSlot,
        [parameter(Mandatory = $true)]
        [AllowNull()]
        [int64]$BeforeSlot
    )
    $tests = @()
    @($AfterSlot,$BeforeSlot).Where({ $_ }).ForEach({
        $tests += @{ Result = $_ -ge 0 }
    })
    if($AfterSlot -and $BeforeSlot){
        $tests += @{ Result = $AfterSlot -lt $BeforeSlot }
    }
    return $tests.Result -notcontains $false
}
