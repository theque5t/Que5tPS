function Get-BlockfrostApiResponse
    (
        $apiHost="cardano-mainnet.blockfrost.io", $version="v0", $path
    )
    {
        $params = @{
            Uri = "https://$apiHost/api/$version/$path"
            Headers = @{ 'project_id' = $env:BLOCKFROST_API_KEY }
        }
        Invoke-RestMethod @params
}

Get-BlockfrostApiResponse -Path "blocks/latest"