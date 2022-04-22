function Format-CardanoWalletSummary {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $_labelPrefix = @{ Object = '  - '; NoNewline = $true }
    $_valuePrefix = @{ Object = '    '; NoNewline = $true }
    
    $_header = @(
        @{ Object = '=' * 126 }
        @{ Object = ' ' * 56 + 'WALLET SUMMARY' + ' ' * 56 }
        @{ Object = '=' * 126 }
    )

    $_network = @(
        @{ Object = '+---------+' + '-' * 115; ForegroundColor = 'DarkGray' }
        @{ Object = '| NETWORK | Description: State of network associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+---------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletNetworkStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    $_tokens = @(
        @{ Object = '+--------+' + '-' * 116; ForegroundColor = 'DarkGray' }
        @{ Object = '| TOKENS | Description: State of tokens associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletTokensStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    $_transactions = @(
        @{ Object = '+--------------+' + '-' * 110; ForegroundColor = 'DarkGray' }
        @{ Object = '| TRANSACTIONS | Description: State of transactions associated to wallet'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-CardanoWalletTransactionsStatus -Wallets $Wallets | Format-Table | Out-String }
    )

    $_footer = @(
        @{ Object = '=' * 126 }
    )

    Write-HostBatch $(
        $_header + 
        $_network +
        $_tokens +
        $_transactions +
        $_footer
    )
}
