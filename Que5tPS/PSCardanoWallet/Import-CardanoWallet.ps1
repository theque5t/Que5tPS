function Import-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingName')]
        [string]$Name,
        [Parameter(ParameterSetName = 'UsingName')]
        [System.IO.DirectoryInfo]
        $WorkingDir = $(Get-Item "$($env:CARDANO_HOME)\wallets"),
        [Parameter(Mandatory = $true, ParameterSetName = 'UsingStateFile')]
        [System.IO.FileInfo]
        $StateFile
    )
    switch ($PsCmdlet.ParameterSetName) {
        'UsingName' {
            $walletDir = Get-Item -Path "$($WorkingDir.FullName)\$Name"
            $wallet = New-Object CardanoWallet -Property @{
                WorkingDir = $WorkingDir
                WalletDir = $walletDir
                StateFile = "$($walletDir.FullName)\state.yaml"
                TransactionsDir = "$($walletDir.FullName)\transactions"
            }
        }
        'UsingStateFile'{
            $workingDir = $StateFile.Directory.Parent
            $walletDir = $StateFile.Directory
            $wallet = New-Object CardanoWallet -Property @{
                WorkingDir = $workingDir
                WalletDir = $walletDir
                StateFile = $StateFile
                TransactionsDir = "$($walletDir.FullName)\transactions"
            }
        }
    }
    Import-CardanoWalletState -Wallet $Wallet
    return $wallet
}
