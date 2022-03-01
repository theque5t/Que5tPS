function Update-CardanoTransactionState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction        
    )
    $Transaction | Export-CardanoTransactionState
    $Transaction | Import-CardanoTransactionState
}
