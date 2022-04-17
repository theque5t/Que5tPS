function Register-CardanoNodeSocketPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $envSessionSocketVar = "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_SOCKET"
    if(-not $(Test-Path $envSessionSocketVar)){
        $process = Get-CardanoNodeProcess -Network $Network
        $pattern = '--socket-path\s(?<socket_path>.*?)\s-'
        $process.CommandLine -match $pattern | Out-Null
        New-Item $envSessionSocketVar -Value $Matches.socket_path | Out-Null
        Write-VerboseLog `
            "Registered Cardano node socket path to $($(Get-Item $envSessionSocketVar).Value)"
    }
}
