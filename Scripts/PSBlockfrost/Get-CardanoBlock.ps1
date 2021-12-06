function Get-CardanoBlock {
    param(
        [Parameter(Mandatory=$true)]
        $Block
    )
    return Get-BlockfrostApiResponse -ApiPath "blocks/$Block"
}
