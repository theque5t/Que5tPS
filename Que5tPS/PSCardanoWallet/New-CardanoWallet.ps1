function New-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [System.IO.DirectoryInfo]
        $WorkingDir = $(Get-Item "$($env:CARDANO_HOME)\wallets\$Network")
    )
    
    $wallet = New-Object CardanoWallet -Property @{
        WorkingDir = $WorkingDir
        Name = $Name
        StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
        Network = $Network
    }
    Assert-CardanoWalletStateFileDoesNotExist -Wallet $wallet
    Update-CardanoWallet -Wallet $wallet
    return $wallet
}
