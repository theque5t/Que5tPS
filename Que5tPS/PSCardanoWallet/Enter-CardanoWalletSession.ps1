function Enter-CardanoWalletSession {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet[]]$Wallets
    )
    $Wallets.ForEach({
        $network = Get-CardanoWalletNetwork -Wallet $_
        Assert-CardanoNodeInSync -Network $network
    })
    try{
        function Get-WalletSelection($Wallets) {
            $selection = Get-OptionSelection `
                -Instruction 'Select a wallet:' `
                -Options $Wallets `
                -OptionDisplayTemplate @(
                    @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
                    @{ Object = ')' },
                    @{ Object = ' | Name: ' ; NoNewline = $true },
                    @{ Expression = '$($option.Value.Name)'; ForegroundColor = 'Green' },
                    @{ Object = ' | Description: ' ; NoNewline = $true },
                    @{ Expression = '$($option.Value.Description)'; ForegroundColor = 'Green' },
                    @{ NoNewline = $false }
                )
            return $selection
        }

        do{
            Format-CardanoWalletSummary -Wallets $Wallets
         
            $actionSelection = Get-OptionSelection `
                -Instruction 'Select an option:' `
                -Options @(
                    'Browse Config'
                    'Browse Tokens'
                    'Browse Transactions'
                    'Add Key Pair'
                    'Add Address'
                    'Perform Transaction'
                    'Mint Tokens'
                    'Exit'
                )
        
            switch($actionSelection){
                'Browse Config'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Get-CardanoWalletStateFileContent `
                        -Wallet $walletSelection `
                        -Colored

                    Wait-Enter
                }
                'Browse Tokens'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Get-CardanoWalletTokens -Wallet $walletSelection

                    Wait-Enter
                }
                'Browse Transactions'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets
                
                    Get-CardanoWalletTransactions -Wallet $walletSelection

                    Wait-Enter
                }
                'Add Key Pair'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Add-CardanoWalletKeyPair `
                        -Wallet $walletSelection `
                        -Name $(
                            Get-FreeformInput `
                                -Instruction "Specify a name for the key pair:" `
                                -InputType 'string' `
                                -ValidationType TestCommand `
                                -ValidationParameters @{ 
                                    Command = 'Test-CardanoWalletKeyPairNameIsValid'
                                    CommandArgs = @{ Wallet = $walletSelection }
                                    ValueArg = 'Name' 
                                }
                        ) `
                        -Description $(
                            Get-FreeformInput `
                                -Instruction "Specify a description for the key pair:" `
                                -InputType 'string'
                        ) `
                        -Password $(
                            Get-PasswordInput `
                                -Instruction "Specify a password for the key pair:" `
                        )
                }
                'Add Address'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Add-CardanoWalletAddress `
                        -Wallet $walletSelection `
                        -Name $(
                            Get-FreeformInput `
                                -Instruction "Specify a name for the address:" `
                                -InputType 'string' `
                                -ValidationType TestCommand `
                                -ValidationParameters @{ 
                                    Command = 'Test-CardanoWalletAddressNameIsValid'
                                    CommandArgs = @{ Wallet = $walletSelection }
                                    ValueArg = 'Name' 
                                }
                        ) `
                        -Description $(
                            Get-FreeformInput `
                                -Instruction "Specify a description for the address:" `
                                -InputType 'string'
                        ) `
                        -KeyPairName $(
                            Get-OptionSelection `
                                -Instruction 'Select a key pair to associate to the address:' `
                                -Options $(Get-CardanoWalletKeyPairs -Wallet $walletSelection)`
                                -OptionDisplayTemplate @(
                                    @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
                                    @{ Object = ')' },
                                    @{ Object = ' | Name: ' ; NoNewline = $true },
                                    @{ Expression = '$($option.Value.Name)'; ForegroundColor = 'Green' },
                                    @{ Object = ' | Description: ' ; NoNewline = $true },
                                    @{ Expression = '$($option.Value.Description)'; ForegroundColor = 'Green' },
                                    @{ NoNewline = $false }
                                )
                        ).Name `
                        -Password $(
                            Get-PasswordInput `
                                -Instruction "Specify the password for the key pair:" `
                        )
                }
                'Perform Transaction'{

                }
                'Mint Tokens'{
    
                }
                'Exit'{
                    Exit-CardanoWalletSession
                }
            }
        }
        while($true)
    }
    catch{
        if($_.Exception.Message -ne 'Exit'){ $_ }
    }
    Format-CardanoWalletSummary -Wallets $Wallets
}
