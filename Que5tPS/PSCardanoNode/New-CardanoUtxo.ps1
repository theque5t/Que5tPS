function New-CardanoUtxo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$Address,
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
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
