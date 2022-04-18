function Import-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingDefault')]
        [string]$Name,
        [Parameter(Mandatory=$true, ParameterSetName = 'UsingDefault')]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(ParameterSetName = 'UsingDefault')]
        [System.IO.DirectoryInfo]
        $WorkingDir = $(Get-Item "$($env:CARDANO_HOME)\wallets\$Network"),
        [Parameter(ParameterSetName = 'UsingStateFile')]
        [System.IO.FileInfo]
        $StateFile
    )
    switch ($PsCmdlet.ParameterSetName) {
        'UsingDefault' {
            $wallet = New-Object CardanoWallet -Property @{
                WorkingDir = $WorkingDir
                StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
            }
        }
        'UsingStateFile'{
            $wallet = New-Object CardanoWallet -Property @{
                WorkingDir = $StateFile.Directory
                StateFile = $StateFile
            }
        }
    }
    Assert-CardanoWalletStateFileExists -Wallet $wallet
    Import-CardanoWalletState -Wallet $Wallet
    return $wallet
}
