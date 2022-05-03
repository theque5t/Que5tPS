function Format-CardanoWalletSummary {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    
    $_header = @(
        @{ Object = '=' * 129 }
        @{ Object = ' ' * 57 + 'WALLET SUMMARY' + ' ' * 58 }
        @{ Object = '=' * 129 }
    )

    $_config = @(
        @{ Object = '+---------------+' + '-' * 112; ForegroundColor = 'DarkGray' }
        @{ Object = '| CONFIGURATION | Description: Configuration associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+---------------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletConfigurationStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    $_network = @(
        @{ Object = '+---------+' + '-' * 118; ForegroundColor = 'DarkGray' }
        @{ Object = '| NETWORK | Description: State of network associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+---------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletNetworkStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    $_tokens = @(
        @{ Object = '+--------+' + '-' * 119; ForegroundColor = 'DarkGray' }
        @{ Object = '| TOKENS | Description: State of tokens associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletTokensStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    $_transactions = @(
        @{ Object = '+--------------+' + '-' * 113; ForegroundColor = 'DarkGray' }
        @{ Object = '| TRANSACTIONS | Description: State of transactions associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletTransactionsStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    Write-HostBatch $(
        $_header + 
        $_config +
        $_network +
        $_tokens +
        $_transactions
    )
}
