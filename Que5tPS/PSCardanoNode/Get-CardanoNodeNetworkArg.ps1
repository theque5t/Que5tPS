function Get-CardanoNodeNetworkArg {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $networkArg = "--$Network"
    $networkArgValue = ''
    if($Network -eq 'testnet'){
        $networkArg = $networkArg + "-magic"
        $networkArgValue = 1097911063
    }
    return @($networkArg, $networkArgValue)
}
