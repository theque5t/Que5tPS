function Update-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction | Export-CardanoTransactionState
    $Transaction | Import-CardanoTransactionState
}
