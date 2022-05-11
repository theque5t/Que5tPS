function Set-CardanoMintContractWitnesses {
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract,
        [Parameter(Mandatory = $true, ParameterSetName = 'VerificationKeys')]
        [securestring[]]$VerificationKeys,
        [Parameter(Mandatory = $true, ParameterSetName = 'Witnesses')]
        [string[]]$Witnesses,
        [bool]$UpdateState = $true
    )
    if($VerificationKeys){
        $Witnesses = [string[]]@()
        $network = Get-CardanoMintContractNetwork -MintContract $MintContract
        $mintContractDir = Get-CardanoMintContractDirectory -MintContract $MintContract
        $VerificationKeys.ForEach({
            $Witnesses += Get-CardanoVerificationKeyHash `
                -Network $network `
                -WorkingDir $mintContractDir `
                -VerificationKey $_
        })
    }
    $MintContract.Witnesses = $Witnesses
    if($UpdateState){
        Update-CardanoMintContract -MintContract $MintContract
    }
}
