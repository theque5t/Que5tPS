function Get-CardanoAddressesUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory = $true)]
        [string[]]$Addresses,
        [Parameter(Mandatory = $true)]
        $WorkingDir,
        [bool]$RemoveOutputFile = $true
    )
    $addressesUtxos = [CardanoUtxo[]]@()
    $Addresses.ForEach({
        $addressesUtxos += Get-CardanoAddressUtxos `
            -Network $Network `
            -Address $_ `
            -WorkingDir $Transaction.WorkingDir
    })
    return $addressesUtxos
}
