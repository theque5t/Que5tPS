function Get-CardanoTransactionUtxos {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse `
        -Network $Network `
        -ApiPath "txs/$Hash/utxos"
}
