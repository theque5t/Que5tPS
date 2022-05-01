function New-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [System.IO.DirectoryInfo]
        $WorkingDir = $(Get-Item "$($env:CARDANO_HOME)\wallets")
    )
    $walletDir = "$($WorkingDir.FullName)\$Name"
    $transactionDir = "$walletDir\transactions"
    $wallet = New-Object CardanoWallet -Property @{
        WorkingDir = $WorkingDir
        WalletDir = $walletDir
        Name = $Name
        Description = $Description
        Network = $Network
        StateFile = "$walletDir\state.yaml"
        TransactionsDir = $transactionDir
    }
    Assert-CardanoWalletDirectoryDoesNotExist -Wallet $wallet
    New-Item -Path $walletDir -ItemType Directory | Out-Null
    New-Item -Path $transactionDir -ItemType Directory | Out-Null
    Update-CardanoWallet -Wallet $wallet
    return $wallet
}
