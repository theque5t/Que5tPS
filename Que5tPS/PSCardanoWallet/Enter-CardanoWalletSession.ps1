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
        $nameDescriptionOptionTemplate = @(
            @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
            @{ Object = ')' },
            @{ Object = ' | Name: ' ; NoNewline = $true },
            @{ Expression = '$($option.Value.Name)'; ForegroundColor = 'Green' },
            @{ Object = ' | Description: ' ; NoNewline = $true },
            @{ Expression = '$($option.Value.Description)'; ForegroundColor = 'Green' },
            @{ NoNewline = $false }
        )
        function Get-WalletSelection($Wallets) {
            $selection = Get-OptionSelection `
                -Instruction 'Select a wallet:' `
                -Options $Wallets `
                -OptionDisplayTemplate $nameDescriptionOptionTemplate
            return $selection
        }

        function Get-KeyPairSelection($Wallet) {
            $selection = Get-OptionSelection `
                -Instruction 'Select a key pair to associate to the address:' `
                -Options $(Get-CardanoWalletKeyPairs -Wallet $Wallet)`
                -OptionDisplayTemplate $nameDescriptionOptionTemplate
            return $selection.Name
        }

        do{
            Format-CardanoWalletSummary -Wallets $Wallets
         
            $actionSelection = Get-OptionSelection `
                -Instruction 'Select an option:' `
                -Options @(
                    'Browse Config'
                    'Browse UTXOs'
                    'Browse Tokens'
                    'Browse Transactions'
                    'New Key Pair'
                    'Import Key Pair'
                    'New Address'
                    'Import Address'
                    'New Transaction'
                    'Continue Transaction'
                    'Mint Tokens'
                    'Exit'
                )
        
            switch($actionSelection){
                'Browse Config'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Get-CardanoWalletStateFileContent -Wallet $walletSelection |
                        Format-ColoredYaml

                    Wait-Enter
                }
                'Browse UTXOs'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Get-CardanoWalletUtxos -Wallet $walletSelection |
                        ConvertTo-Yaml |
                        Format-ColoredYaml

                    Wait-Enter
                }
                'Browse Tokens'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Get-CardanoWalletTokens -Wallet $walletSelection |
                        Format-Table |
                        Out-String

                    Wait-Enter
                }
                'Browse Transactions'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets
                
                    Get-CardanoWalletTransactions -Wallet $walletSelection |
                        Format-Table |
                        Out-String

                    Wait-Enter
                }
                'New Key Pair'{
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
                'Import Key Pair'{
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
                        -VerificationKey $(
                            Get-FreeformInput `
                                -Instruction "Specify the encrypted key pair verification key:" `
                                -InputType 'string'
                        ) `
                        -SigningKey $(
                            Get-FreeformInput `
                                -Instruction "Specify the encrypted key pair signing key:" `
                                -InputType 'string'
                        )
                }
                'New Address'{
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
                            Get-KeyPairSelection -Wallet $walletSelection
                        ) `
                        -Password $(
                            Get-PasswordInput `
                                -Instruction "Specify the password for the key pair:" `
                        )
                }
                'Import Address' {
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
                            Get-KeyPairSelection -Wallet $walletSelection
                        ) `
                        -Hash $(
                            Get-FreeformInput `
                                -Instruction "Specify the address hash:" `
                                -InputType 'string'
                        ) `
                }
                'New Transaction'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets
                    
                    $transaction = Add-CardanoWalletTransaction `
                        -Wallet $walletSelection `
                        -Name $(
                            Get-FreeformInput `
                                -Instruction "Specify a name for the transaction:" `
                                -InputType 'string' `
                                -ValidationType TestCommand `
                                -ValidationParameters @{ 
                                    Command = 'Test-CardanoWalletTransactionNameIsValid'
                                    CommandArgs = @{ Wallet = $walletSelection }
                                    ValueArg = 'Name' 
                                }
                        )
                    
                    Set-CardanoTransaction `
                        -Transaction $transaction `
                        -Addresses $(
                            Get-CardanoWalletAddresses `
                                -Wallet $walletSelection
                        ).Hash `
                        -Interactive
                }
                'Continue Transaction'{
                    $walletSelection = Get-WalletSelection -Wallets $Wallets

                    Set-CardanoTransaction `
                        -Transaction $(
                            Get-CardanoWalletCurrentTransaction `
                                -Wallet $walletSelection
                        ) `
                        -Addresses $(
                            Get-CardanoWalletAddresses `
                                -Wallet $walletSelection
                        ).Hash `
                        -Interactive
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
