function Get-CardanoWallets {
    [CmdletBinding()]
    param()
    Assert-CardanoHomeExists
    Write-VerboseLog "Getting wallets..."
    $wallets = Get-ChildItem "$env:CARDANO_HOME"
    return $wallets
}
