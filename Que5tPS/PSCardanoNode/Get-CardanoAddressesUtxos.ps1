function Get-CardanoAddressesUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$Addresses,
        [Parameter(Mandatory = $true, Position = 1)]
        $WorkingDir,
        [Parameter(Position = 2)]
        [bool]$RemoveOutputFile = $true
    )
    $addressesUtxos = [CardanoUtxo[]]@()
    $Addresses.ForEach({
        $addressesUtxos += Get-CardanoAddressUtxos -Address $_ -WorkingDir $Transaction.WorkingDir
    })
    return $addressesUtxos
}
