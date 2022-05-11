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
        # [Parameter(Mandatory=$true)]
        [ValidateSet('CardanoCLI','CardanoWallet','SomeOtherWalletProvider')]
        $Provider,
        [System.IO.DirectoryInfo]
        $WorkingDir = $(Get-Item "$($env:CARDANO_HOME)\wallets")
    )
    if($Provider){ 
        Write-Warning $(
            "Provider is not yet implemented.`n" + 
            "Currently CardanoCLI is the only wallet provider.`n" +
            "To see the basics of how CardanoCLI provider works, checkout:`n" +
            "https://developers.cardano.org/docs/integrate-cardano/creating-wallet-faucet#creating-a-wallet-with-cardano-cli`n" +
            "To see the basics of how CardanoWallet provider will work (contributions welcome!), checkout:`n" +
            "https://developers.cardano.org/docs/integrate-cardano/creating-wallet-faucet#creating-a-wallet-with-cardano-wallet"
        )
    }
    $walletDir = "$($WorkingDir.FullName)\$Name"
    $transactionDir = "$walletDir\transactions"
    $tokenDiesDir = "$walletDir\tokenDies"
    $wallet = New-Object CardanoWallet -Property @{
        WorkingDir = $WorkingDir
        WalletDir = $walletDir
        Name = $Name
        Description = $Description
        Network = $Network
        StateFile = "$walletDir\state.yaml"
        TransactionsDir = $transactionDir
        TokenDiesDir = $tokenDiesDir
    }
    Assert-CardanoWalletDirectoryDoesNotExist -Wallet $wallet
    New-Item -Path $walletDir -ItemType Directory | Out-Null
    New-Item -Path $transactionDir -ItemType Directory | Out-Null
    New-Item -Path $tokensDir -ItemType Directory | Out-Null
    Update-CardanoWallet -Wallet $wallet
    return $wallet
}
