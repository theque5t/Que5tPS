function Get-CardanoTransactionNetwork {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.Network
}
