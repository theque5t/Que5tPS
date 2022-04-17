function Get-CardanoNodeProcess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network
    )
    $nodePath = Get-CardanoNodePath -Network $Network
    $process = $(Get-Process).Where({ 
        $_.Name -eq 'cardano-node' -and
        $_.Path -eq "$nodePath\cardano-node.exe"
    })

    return $process
}
