function Get-CardanoAddressesUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [string[]]$Addresses,
        [Parameter(Mandatory = $true)]
        $WorkingDir,
        [bool]$RemoveOutputFile = $true
    )
    Assert-CardanoNodeInSync -Network $Network
    $addressesUtxos = [CardanoUtxo[]]@()
    $Addresses.ForEach({
        $addressesUtxos += Get-CardanoAddressUtxos `
            -Network $Network `
            -Address $_ `
            -WorkingDir $WorkingDir
    })
    return $addressesUtxos
}
