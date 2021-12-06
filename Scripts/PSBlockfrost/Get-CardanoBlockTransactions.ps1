function Get-CardanoBlockTransactions {
    param(
        [Parameter(Mandatory=$true)]
        $Block
    )
    return Get-BlockfrostApiResponse -ApiPath "blocks/$Block/txs"
}
