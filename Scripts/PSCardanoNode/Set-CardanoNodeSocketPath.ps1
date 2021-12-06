function Set-CardanoNodeSocketPath {
    [CmdletBinding()]
    param()
    if(-not $env:CARDANO_NODE_SOCKET_PATH){
        $process = Get-CardanoNodeProcess
        $pattern = '--socket-path\s(?<socket_path>.*?)\s-'
        $process.CommandLine -match $pattern | Out-Null
        $env:CARDANO_NODE_SOCKET_PATH = $Matches.socket_path
        Write-VerboseLog `
            "Set Cardano node socket path to $env:CARDANO_NODE_SOCKET_PATH"
    }
}
