function Import-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingName')]
        [string]$Name,
        [Parameter(ParameterSetName = 'UsingName')]
        [System.IO.DirectoryInfo]
        $WorkingDir = $(Get-Item "$($env:CARDANO_HOME)\wallets"),
        [Parameter(ParameterSetName = 'UsingStateFile')]
        [System.IO.FileInfo]
        $StateFile
    )
    switch ($PsCmdlet.ParameterSetName) {
        'UsingName' {
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
