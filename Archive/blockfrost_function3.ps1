function Get-BlockfrostApiResponse(
        $Path,
        $apiHost="cardano-mainnet.blockfrost.io",
        $version="v0")
    {
        $Uri = "https://$apiHost/api/$version/$path"
        $Headers = @{ 'project_id' = $env:BLOCKFROST_API_KEY }
        New-Connection $Uri $Headers
    }

function New-Connection($Uri, $Headers){
        Invoke-RestMethod @PSBoundParameters
    }

Get-BlockfrostApiResponse "blocks/latest"