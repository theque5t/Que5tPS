function Set-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [parameter(Mandatory = $true)]
        $SigningKeys,
        [bool]$UpdateState = $true
    )
    $SigningKeys = ConvertTo-CardanoKeySecureStringList -Objects $SigningKeys
    Update-CardanoTransaction -Transaction $Transaction -SigningKeys $SigningKeys
    $($Transaction.SignedBodyHash = Get-CardanoTransactionBodyHash -Transaction $Transaction)
    if($UpdateState){
        Update-CardanoTransaction -Transaction $Transaction
    }
}
