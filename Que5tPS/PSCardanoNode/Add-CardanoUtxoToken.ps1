function Add-CardanoUtxoToken {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo]$Utxo,
        [Parameter(Mandatory = $true)]
        [CardanoToken]$Token
    )
    $Utxo.Value += $Token
}
