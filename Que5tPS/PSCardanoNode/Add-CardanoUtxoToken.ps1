function Add-CardanoUtxoToken {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoUtxo]$Utxo,
        [Parameter(Mandatory = $true)]
        [CardanoToken]$Token
    )
    $Utxo.Value += $Token
}
