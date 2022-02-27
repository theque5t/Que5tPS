function New-CardanoUtxo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,
        [Parameter(Mandatory = $true)]
        [string]$Address,
        [Parameter(Mandatory = $true)]
        [string]$Data
    )
    $utxo = [CardanoUtxo]::new()
    $utxo.Id = $Id
    $utxo.TxHash = $Id.Split('#')[0]
    $utxo.Index = $Id.Split('#')[1]
    $utxo.Address = $Address
    $utxo.Data = $Data
    return $utxo
}
