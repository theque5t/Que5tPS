function Get-BlockfrostApiResponse {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        $ApiPath,
        $Method = 'Get',
        $ApiHost = "cardano-$Network.blockfrost.io",
        $ApiVersion = 'v0',
        $BlockfrostApiKey = $(Get-Item -Path "env:BLOCKFROST_API_KEY_$($Network.ToUpper())").Value
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
