function Get-BlockfrostApiResponse($Path){
    New-Connection -Path $Path
}

function New-Connection(
        $apiHost="cardano-mainnet.blockfrost.io",
        $version="v0",
        $Path)
    {
        $params = @{
            Uri = "https://$apiHost/api/$version/$path"
            Headers = @{ 'project_id' = $env:BLOCKFROST_API_KEY }
        }
        Invoke-RestMethod @params
    }

Get-BlockfrostApiResponse "blocks/latest"