function Get-CardanoAddressTransactions {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        $Address
    )
    return Get-BlockfrostApiResponse `
        -Network $Network `
        -ApiPath "addresses/$Address/transactions"
}
