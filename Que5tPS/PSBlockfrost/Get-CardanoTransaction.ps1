function Get-CardanoTransaction {
    param(
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse -ApiPath "txs/$Hash"
}
