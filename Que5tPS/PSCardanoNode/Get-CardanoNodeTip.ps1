function Get-CardanoNodeTip {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    try{
        $socket = Get-CardanoNodeSocket -Network $Network
        $nodePath = Get-CardanoNodePath -Network $Network
        $networkArgs = Get-CardanoNodeNetworkArg -Network $Network
        $_args = @('query', 'tip', $networkArgs)
        $query = Invoke-CardanoCLI `
            -Socket $socket `
            -Path $nodePath `
            -Arguments $_args
        return $($query | ConvertFrom-Json)
    }
    catch{}
}
