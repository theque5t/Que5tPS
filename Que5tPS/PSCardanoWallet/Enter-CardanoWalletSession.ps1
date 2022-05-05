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
            Clear-CardanoWalletUnsubmittedTransactions -Wallets $Wallets

            Format-CardanoWalletSummary -Wallets $Wallets

            $actionSelection = Get-OptionSelection `
                -Instruction 'Select an option:' `
                -Options @(
                    'Wallet Action'
                    'Exit'
                )

            switch($actionSelection){
                'Wallet Action'{
                    $walletSelection = Get-OptionSelection `
                    -Instruction 'Select a wallet:' `
                    -Options $Wallets `
                    -OptionDisplayTemplate $nameDescriptionOptionTemplate

                    $walletActionSelection = Get-OptionSelection `
                        -Instruction 'Select an option:' `
                        -Options @(
                            'Browse Config'
                            if(Test-CardanoWalletHasUtxos -Wallet $walletSelection){
                                'Browse UTXOs'
                            }
                            if(Test-CardanoWalletHasTokens -Wallet $walletSelection){
                                'Browse Tokens'
                            }
                            if(Test-CardanoWalletHasTransactions -Wallet $walletSelection){
                                'Browse Transactions'
                            }
                            'New Key Pair'
                            'Import Key Pair'
                            if(Test-CardanoWalletHasKeyPair -Wallet $walletSelection){
                                'New Address'
                                'Import Address'
                            }
                            if(Test-CardanoWalletHasAddress -Wallet $walletSelection){
                                'Perform Transaction'
                                'Mint Tokens'
                            }
                            'Back'
                        )
                    
                    switch($walletActionSelection){
                        'Browse Config'{
                            Get-CardanoWalletStateFileContent -Wallet $walletSelection |
                                Format-ColoredYaml

                            Wait-Enter
                        }
                        'Browse UTXOs'{
                            Get-CardanoWalletUtxos -Wallet $walletSelection |
                                ConvertTo-Yaml |
                                Format-ColoredYaml

                            Wait-Enter
                        }
                        'Browse Tokens'{
                            Get-CardanoWalletTokens -Wallet $walletSelection |
                                Format-Table |
                                Out-String

                            Wait-Enter
                        }
                        'Browse Transactions'{
                            do{
                                $transactionSelection = Get-OptionSelection `
                                    -Instruction 'Select which transaction to browse:' `
                                    -Options $(Get-CardanoWalletTransactions -Wallet $walletSelection)`
                                    -OptionDisplayTemplate $nameDescriptionOptionTemplate
                            
                                Format-CardanoTransactionSummary -Transaction $transactionSelection

                                $continueSelection = Get-OptionSelection `
                                    -Instruction 'Select an option:' `
                                    -Options @(
                                        'Continue browsing'
                                        'Done browsing'
                                    )
                            }
                            while($continueSelection -eq 'Continue browsing')
                        }
                        'New Key Pair'{
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
                        'Perform Transaction'{
                            $addressesSelection = Get-OptionSelection `
                                -MultipleChoice `
                                -Instruction $(
                                    'Select which address(es) to associate to the transaction:' +
                                    "`nSeperate numbers using a comma.`n"
                                ) `
                                -Options $(Get-CardanoWalletAddresses -Wallet $walletSelection)`
                                -OptionDisplayTemplate $nameDescriptionOptionTemplate
                            
                            $signingKeys = $(
                                Get-CardanoWalletKeys `
                                    -Wallet $walletSelection `
                                    -KeyPairNames $addressesSelection.KeyPairName `
                                    -Decrypt
                            ).SigningKey
                            
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
                                ) `
                                -Description $(
                                    Get-FreeformInput `
                                        -Instruction "Specify a description for the transaction:" `
                                        -InputType 'string'
                                )
                            
                            Set-CardanoTransaction `
                                -Transaction $transaction `
                                -Addresses $addressesSelection.Hash `
                                -SigningKeys $signingKeys
                        }
                        'Mint Tokens'{
                            Write-Host 'TODO: Not implemented yet'
                            Wait-Enter
                        }
                    }
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
