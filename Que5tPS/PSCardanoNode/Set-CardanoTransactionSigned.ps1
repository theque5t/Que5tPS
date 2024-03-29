function Set-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        $SigningKeys,
        [bool]$UpdateState = $true,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    $SigningKeys = ConvertTo-CardanoKeySecureStringList -Objects $SigningKeys
    Update-CardanoTransaction -Transaction $Transaction -SigningKeys $SigningKeys
    Set-CardanoTransactionSignedStateHash `
        -Transaction $Transaction `
        -Hash $(Get-CardanoTransactionStateHash -Transaction $Transaction)
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
