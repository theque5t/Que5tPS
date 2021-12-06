function Get-CardanoWalletAddressFiles {
    [CmdletBinding()]
    param()
    Assert-CardanoWalletSessionIsOpen
    Write-VerboseLog "Getting wallet address file..."
    $walletPath = $(Get-CardanoWallet).FullName
    $walletAddresses = Get-ChildItem $walletPath\addresses
    return $walletAddresses
}
