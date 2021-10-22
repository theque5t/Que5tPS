function get_blockfrost_api_response(
        $Path,
        $apiHost="cardano-mainnet.blockfrost.io",
        $version="v0",
        $Uri = "https://$apiHost/api/$version/$Path",
        $Headers = @{ 'project_id' = $env:BLOCKFROST_API_KEY })
    {
        Set-Alias connection Invoke-RestMethod -Option private
        connection -Uri $Uri -Headers $Headers
    }

get_blockfrost_api_response "blocks/latest"