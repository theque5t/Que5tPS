function Update-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [securestring[]]$SigningKeys,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    Export-CardanoTransactionSigned -Transaction $Transaction -SigningKeys $SigningKeys
    Import-CardanoTransactionSigned -Transaction $Transaction
}
