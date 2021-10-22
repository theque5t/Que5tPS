class BlockfrostApi {
    $ApiHost = "cardano-mainnet.blockfrost.io"
    $Version = "v0"
    [Object] Get($Path){
        $params = @{
            Uri = "https://$($this.ApiHost)/api/$($this.version)/$Path"
            Headers = @{ 'project_id' = $env:BLOCKFROST_API_KEY }
        }
        return Invoke-RestMethod @params
    }
}

$api = [BlockfrostApi]::new()
$api.Get("blocks/latest")