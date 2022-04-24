function Get-CardanoWalletConfigurationStatus {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    # Transactions High-level
    #           Un-Submitted | Submitted | Most Recent | Last Updated    | Total Recieved | Total Sent
    # wallet1 | 1000         | 5         | tx3         | 4/19/2022 21:22 | TBD/Nice2Have  | TBD/Nice2Have
    # wallet2 | 200          | 10        | tx3         | 4/19/2022 21:22 | TBD/Nice2Have  | TBD/Nice2Have

    $walletConfigurationStatus = @()
    $Wallets.ForEach({
        $walletConfigurationStatus += [PSCustomObject]@{
            Wallet = Get-CardanoWalletName -Wallet $_
            Description = Get-CardanoWalletDescription -Wallet $_
            Network = Get-CardanoWalletNetwork -Wallet $_
            KeyPairs = $(Get-CardanoWalletKeyPairs -Wallet $_).Count
            Addresses = $(Get-CardanoWalletAddresses -Wallet $_).Count
            LastModified = $(Get-CardanoWalletStateFile -Wallet $_).LastWriteTime
        }
    })
    return $walletConfigurationStatus
}
