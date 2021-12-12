function Get-BlockfrostApiResponse {
    param(
        $Method = 'Get',
        $ApiHost = 'cardano-mainnet.blockfrost.io',
        $ApiVersion = 'v0',
        $ApiPath,
        $BlockfrostApiKey = $env:BLOCKFROST_API_KEY
    )
    try{
        $uri = "https://$ApiHost/api/$ApiVersion/$ApiPath"

        $headers = @{
            'project_id' = $BlockfrostApiKey
        }

        Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers
    }
    catch {
        $_.Exception.Message
        $_.ScriptStackTrace
    }
}
