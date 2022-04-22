function Enter-CardanoWalletSession {
    [CmdletBinding()]
    param()
    # Assert-CardanoWalletSessionIsOpen
    try{
        do{
            # $interactionComplete = $false
            # $wallets = Get-CardanoWalletSessionWallets
            # Format-CardanoWalletSummary -Wallets $wallets
        
            $actionSelection = Get-OptionSelection `
                -Instruction 'Select an option:' `
                -Options @(
                    'Browse Tokens'
                    'Browse Transactions'
                    'Add Key Pair'
                    'Add Address'
                    'Perform Transaction'
                    'Mint Tokens'
                    'Done Editing'
                )
        
            switch($actionSelection){
                'Browse Tokens'{
    
                }
                'Browse Transactions'{
    
                }
                'Add Key Pair'{
                    $walletPath = $(Get-CardanoWallet $Name).FullName
                    $walletKeys = "$walletPath\keys"
                    $verificationKey = "$walletKeys\$Name.vkey"
                    $signingKey = "$walletKeys\$Name.skey"
                    $_args = @(
                        'address', 'key-gen'
                        '--verification-key-file', $verificationKey
                        '--signing-key-file', $signingKey
                    )
                    Invoke-CardanoCLI @_args
                }
                'Add Address'{
                    $walletPath = $(Get-CardanoWallet $Name).FullName
                    $walletAddresses = "$walletPath\addresses"
                    $walletConfig = Get-CardanoWalletConfig $Name
                    $walletAddress = (
                        "$walletAddresses\" +
                        "$env:CARDANO_NODE_NETWORK$($walletConfig.nextAddressIndex).addr"
                    )
                    $walletVerificationKey = Get-CardanoWalletKeyFile $Name -Type verification
                    $_args = @(
                        'address','build'
                        '--payment-verification-key-file', $walletVerificationKey
                        '--out-file', $walletAddress
                        $env:CARDANO_CLI_NETWORK_ARG
                        $env:CARDANO_CLI_NETWORK_ARG_VALUE
                    )
                    Invoke-CardanoCLI @_args
                }
                'Perform Transaction'{

                }
                'Mint Tokens'{
    
                }
                'Done Editing'{
                    Exit-CardanoWalletSession
                }
            }
        }
        while($true)
    }
    catch{
        if($_.Exception.Message -ne 'Exit'){ $_ }
    }

    # Format-CardanoWalletSummary -Wallets $wallets
}
