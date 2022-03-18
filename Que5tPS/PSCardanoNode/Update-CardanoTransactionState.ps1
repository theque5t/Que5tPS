function Update-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction        
    )
    Export-CardanoTransactionState -Transaction $Transaction
    Import-CardanoTransactionState -Transaction $Transaction
}
