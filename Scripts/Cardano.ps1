function ConvertTo-ADA{
    param(
        [parameter(ValueFromPipeline)]
        $Amount,
        [ValidateSet('Lovelace')]
        $From = 'Lovelace',
        [switch]$WithSymbol = $True
    )
    switch ($From) {
        'Lovelace' { 
            if($Amount.unit -eq 'lovelace'){
                $Amount = $Amount.where({$_.unit -eq 'lovelace'}).quantity
            }
            $ada = $Amount/1000000 }
    }

    if($WithSymbol){
        $ada = "₳ $ada"
    }
    return $ada
}

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

function Get-CardanoEpochLatest {
    return Get-BlockfrostApiResponse -ApiPath 'epochs/latest'
}

function Get-CardanoEpoch {
    param(
        [Parameter(Mandatory=$true)]
        $Epoch
    )
    return Get-BlockfrostApiResponse -ApiPath "epochs/$Epoch"
}

function Get-CardanoBlockLatest {
    return Get-BlockfrostApiResponse -ApiPath 'blocks/latest'
}

function Get-CardanoBlock {
    param(
        [Parameter(Mandatory=$true)]
        $Block
    )
    return Get-BlockfrostApiResponse -ApiPath "blocks/$Block"
}

function Get-CardanoBlockTransactions {
    param(
        [Parameter(Mandatory=$true)]
        $Block
    )
    return Get-BlockfrostApiResponse -ApiPath "blocks/$Block/txs"
}

function Get-CardanoTransaction {
    param(
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse -ApiPath "txs/$Hash"
}

function Get-CardanoTransactionUtxos {
    param(
        [Parameter(Mandatory=$true)]
        $Hash
    )
    return Get-BlockfrostApiResponse -ApiPath "txs/$Hash/utxos"
}

function Invoke-CardanoCLI {
    &"$env:DEADALUS_MAINNET_HOME\cardano-cli.exe" @args
}

Set-Alias -Name cardano-cli -Value Invoke-CardanoCLI

function Set-CardanoNodeSocketPath {
    $process = $(
        Get-Process -Name cardano-node
    ).Where({ 
        $_.Path -eq "$env:DEADALUS_MAINNET_HOME\cardano-node.exe" 
    })

    $pattern = '--socket-path\s(?<socket_path>.*?)\s-'
    $process.CommandLine -match $pattern | Out-Null

    $env:CARDANO_NODE_SOCKET_PATH = $Matches.socket_path
}
