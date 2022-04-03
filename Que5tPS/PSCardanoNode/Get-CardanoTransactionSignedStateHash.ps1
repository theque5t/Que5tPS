function Get-CardanoTransactionSignedStateHash {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction
    )
    return $Transaction.SignedStateHash
}
