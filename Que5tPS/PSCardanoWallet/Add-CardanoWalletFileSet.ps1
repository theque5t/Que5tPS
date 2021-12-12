function Add-CardanoWalletFileSet {
    param(
        [Parameter(Mandatory=$true)]
        $Name
    )
    Assert-CardanoHomeExists
    $walletPath = "$env:CARDANO_HOME\$Name"
    $walletConfig = "$walletPath\.config"
    $walletTemp = "$walletPath\.temp"
    $walletKeys = "$walletPath\keys"
    $walletAddresses = "$walletPath\addresses"
    Write-VerboseLog "Creating wallet file set..."
    @($walletPath,
      $walletConfig,
      $walletTemp,
      $walletKeys,
      $walletAddresses
    ).ForEach({
        New-Item $_ -ItemType Directory | Out-Null
    })
    Assert-CardanoWalletExists $Name
}
