function Get-CardanoTransactionUtxos {
    param(
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse -ApiPath "txs/$Hash/utxos"
}
