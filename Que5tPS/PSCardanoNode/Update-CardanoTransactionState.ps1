function Update-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    Export-CardanoTransactionState -Transaction $Transaction
    Import-CardanoTransactionState -Transaction $Transaction
}
