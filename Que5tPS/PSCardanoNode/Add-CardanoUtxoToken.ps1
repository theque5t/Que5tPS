function Add-CardanoUtxoToken {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)]
        [CardanoUtxo]$Utxo,
        [Parameter(Mandatory = $true)]
        [string]$PolicyId,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$Quantity
    )
    $Utxo.Value += New-CardanoToken `
        -PolicyId $PolicyId `
        -Name $Name `
        -Quantity $Quantity
}
