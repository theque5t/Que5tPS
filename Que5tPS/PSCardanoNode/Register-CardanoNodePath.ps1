function Register-CardanoNodePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Deadalus')]
        $NodeType
    )
    $envSessionPathVar = "env:CARDANO_NODE_SESSION_$($Network.ToUpper())_PATH"
    switch($NodeType){
        'Deadalus'{
            Assert-CardanoNodeInstalled -Network $Network -NodeType $NodeType
            New-Item $envSessionPathVar -Value "C:\Program Files\Daedalus $Network" |
            Out-Null
        }
    }
    Write-VerboseLog "Registered Cardano node path to $($(Get-Item $envSessionPathVar).Value)"
}
