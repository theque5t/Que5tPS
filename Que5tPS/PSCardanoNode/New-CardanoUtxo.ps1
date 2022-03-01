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
    $utxo = New-Object CardanoUtxo -Property @{
        Id = $Id
        TxHash = $Id.Split('#')[0]
        Index = $Id.Split('#')[1]
        Address = $Address
        Data = $Data
    }
    return $utxo
}
