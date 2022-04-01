function Get-CardanoTransactionBodyHash {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $(Get-FileHash $Transaction.BodyFile).Hash
}
