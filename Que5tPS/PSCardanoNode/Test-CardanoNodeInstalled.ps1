function Test-CardanoNodeInstalled {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Deadalus')]
        $NodeType
    )
    switch($NodeType){
        'Deadalus'{
            $result = Test-Path "C:\Program Files\Daedalus $Network"
        }
    }
    return $result
}
