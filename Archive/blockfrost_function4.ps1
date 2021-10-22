function get_blockfrost_api_response(
        $Path,
        $apiHost="cardano-mainnet.blockfrost.io",
        $version="v0")
    {
        $Uri = "https://$apiHost/api/$version/$path"
        $Headers = @{ 'project_id' = $env:BLOCKFROST_API_KEY }
        connection $Uri $Headers
    }

function connection($Uri, $Headers){
        Invoke-RestMethod @PSBoundParameters
    }

get_blockfrost_api_response "blocks/latest"