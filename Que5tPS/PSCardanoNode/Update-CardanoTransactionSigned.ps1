function Update-CardanoTransactionSigned {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [securestring[]]$SigningKeys
    )
    Export-CardanoTransactionSigned -Transaction $Transaction -SigningKeys $SigningKeys
    Import-CardanoTransactionSigned -Transaction $Transaction
}
