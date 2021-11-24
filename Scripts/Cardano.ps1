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
    $output = &"$env:DEADALUS_MAINNET_HOME\cardano-cli.exe" @args 2>&1
    if($LastExitCode){
        $commandException = $output
        throw "$commandException"
    }
    return $output
}

Set-Alias -Name cardano-cli -Value Invoke-CardanoCLI

function Get-CardanoNodeProcess {
    $process = $(Get-Process).Where({ 
        $_.Name -eq 'cardano-node' 
        })
    
    return $process
}
    
function Test-CardanoNodeIsRunning {
    $process = Get-CardanoNodeProcess

    return $process.Count -gt 0
}

function Set-CardanoNodeProcessRunning{
    [CmdletBinding()]
    param()
    
    if(-not $(Test-CardanoNodeIsRunning)){
        Write-VerboseLog 'Starting Cardano node process...'
        Start-Process `
            -FilePath "$env:DEADALUS_MAINNET_HOME\cardano-launcher.exe" `
            -WorkingDirectory $env:DEADALUS_MAINNET_HOME
        
        while(-not $(Test-CardanoNodeIsRunning)){
            Write-VerboseLog 'Waiting for Cardano node to start...'
            Start-Sleep -Seconds 5
        }

        Write-VerboseLog 'Cardano node process started'
    }
}

function Set-CardanoNodeProcessStopped{
    [CmdletBinding()]
    param()

    if($(Test-CardanoNodeIsRunning)){
        Write-VerboseLog 'Stopping Cardano node process...'
        Get-CardanoNodeProcess | Stop-Process
        Write-VerboseLog 'Cardano node process stopped'
    }
}

function Get-CardanoNodeTip {
    param(
        [ValidateSet('mainnet','testnet')]
        $Network = 'mainnet'
    )
    try{
    $query = Invoke-CardanoCLI query tip --$Network
    return $($query | ConvertFrom-Json)
}
    catch{}
}

function Set-CardanoNodeSocketPath {
    [CmdletBinding()]
    param()
    
    if(-not $env:CARDANO_NODE_SOCKET_PATH -and $(Test-CardanoNodeIsRunning)){
        $process = Get-CardanoNodeProcess
        $pattern = '--socket-path\s(?<socket_path>.*?)\s-'
        $process.CommandLine -match $pattern | Out-Null
        $env:CARDANO_NODE_SOCKET_PATH = $Matches.socket_path
        Write-VerboseLog "Set Cardano node socket path to $env:CARDANO_NODE_SOCKET_PATH"
    }
}

function Open-CardanoNodeSession {
    [CmdletBinding()]
    param()
    Write-VerboseLog 'Opening Cardano node session...'

    Set-CardanoNodeProcessRunning
    Set-CardanoNodeSocketPath

    do{
        Write-VerboseLog 'Waiting for Cardano node to respond...'
        Start-Sleep -Seconds 5
    }
    while(-not $(Get-CardanoNodeTip))

    Write-VerboseLog 'Cardano node session opened'
}

function Close-CardanoNodeSession {
    [CmdletBinding()]
    param()

    Write-VerboseLog 'Closing Cardano node session...'
    Set-CardanoNodeProcessStopped
    Remove-Item Env:\CARDANO_NODE_SOCKET_PATH
    Write-VerboseLog 'Cardano node session closed'
}

function Test-CardanoNodeInSync {
    return $(Get-CardanoNodeTip).syncProgress -eq '100.00'
}

function Sync-CardanoNode {
    [CmdletBinding()]
    param()

    Open-CardanoNodeSession
    
    do{
        Write-VerboseLog "Sync percentage: $($(Get-CardanoNodeTip).syncProgress)"
        Start-Sleep -Seconds 5
    }
    while(-not $(Test-CardanoNodeInSync))
}
