function Add-CardanoWalletSessionWallet {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    $env:CARDANO_WALLET_SESSION_PATHS = $(
        @($env:CARDANO_WALLET_SESSION_PATHS
          $Wallet.StateFile
        ).Where({ $_ }) | Sort-Object -Unique
    ) -join ';'
}
