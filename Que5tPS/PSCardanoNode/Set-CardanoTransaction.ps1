function Set-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [string[]]$Addresses,
        $SigningKeys,
        [bool]$ROProtection = $true
    )
    if($ROProtection){
        Assert-CardanoTransactionIsNotReadOnly -Transaction $Transaction
    }
    do{
        $interactionComplete = $false
        $network = Get-CardanoTransactionNetwork -Transaction $Transaction
        Format-CardanoTransactionSummary -Transaction $Transaction
    
        $actionSelection = Get-OptionSelection `
            -Instruction 'Select an option:' `
            -Options @(
                'Set Witness Quantity'
                'Mint Tokens'
                'Burn Tokens'
                'Set UTXO Inputs'
                if(Test-CardanoTransactionHasInputs -Transaction $Transaction){ 
                    'Set Allocation Recipient(s)'
                    'Set Change Recipient' 
                }
                if(Test-CardanoTransactionHasAllocations -Transaction $Transaction){
                    'Set Allocation'
                    'Set Fee Allocation'
                }
                if(Test-CardanoTransactionHasChangeAllocationRecipient -Transaction $Transaction){
                    'Clear Change Recipient'
                }
                if(Test-CardanoTransactionSignable -Transaction $Transaction){
                    'Sign'
                }
                if(Test-CardanoTransactionSubmittable -Transaction $Transaction){
                    'Submit'
                }
                'Done Editing'
            )
    
        switch($actionSelection){
            'Set Witness Quantity' {
                $witnessQuantitySelection = Get-FreeformInput `
                    -Instruction 'Specify the quantity of witnesses (signers)' `
                    -InputType 'Int64'

                Set-CardanoTransactionWitnessQuantity `
                    -Transaction $Transaction `
                    -Quantity $witnessQuantitySelection
            }

            'Mint Tokens' {
                $mintContractsPathSelection = Get-FreeformInput `
                    -Instruction $(
                        "Specify 1 or paths to import mint contracts from (e.g. <C:\path\one\to\mintContracts>,<C:\path\two\to\mintContracts>, ...)." +
                        "`nSeperate paths using a comma."
                    ) `
                    -InputType 'string' `
                    -ValidationType TestCommand `
                    -ValidationParameters @{ Command = 'Test-Path'; ValueArg = 'Path' } `
                    -Delimited

                $mintContractsSelection = Get-OptionSelection `
                    -MultipleChoice `
                    -Instruction $(
                        "Select 1 or more mint contracts to mint from." +
                        "`nSeperate numbers using a comma.`n"
                    ) `
                    -Options $(Get-CardanoTokenDies -Path $mintContractsPathSelection)

            }

            'Burn Tokens' {

            }

            'Set UTXO Inputs' {
                if(-not $Addresses){
                    $Addresses = Get-FreeformInput `
                        -Instruction $(
                            "Specify 1 or more addresses holding UTXOs (e.g. <address1>,<address2>, ...)." +
                            "`nSeperate addresses using a comma."
                        ) `
                        -InputType 'string' `
                        -ValidationType TestCommand `
                        -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid'; ValueArg = 'Address' } `
                        -Delimited
                }
                
                $addressesUtxos = Get-CardanoAddressesUtxos `
                    -Network $network `
                    -Addresses $Addresses `
                    -WorkingDir $Transaction.TransactionDir
    
                $addressesUtxosSelection = Get-OptionSelection `
                    -MultipleChoice `
                    -Instruction $(
                        "Select 1 or more UTXOs to spend." +
                        "`nSeperate numbers using a comma.`n"
                    ) `
                    -Options $addressesUtxos `
                    -OptionDisplayTemplate @(
                        @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
                        @{ Object = ')' },
                        @{ Object = ' | UTXO Id: ' ; NoNewline = $true },
                        @{ Expression = '$($option.Value.Id)'; ForegroundColor = 'Green' },
                        @{ Object = ' | UTXO Data: ' ; NoNewline = $true },
                        @{ Expression = '$($option.Value.Data)'; ForegroundColor = 'Green' },
                        @{ Object = ' | UTXO Holding Address: ' ; NoNewline = $true },
                        @{ Expression = '$($option.Value.Address)'; ForegroundColor = 'Green' }
                        @{ Object = ' | UTXO Tokens:' },
                        @{ Prefix = @{ Object = ' |   '; NoNewline = $true }
                            Expression = '$($option.Value | Select-Object * -ExpandProperty Value | Format-List "PolicyId", "Name", "Quantity" | Out-String)'
                            ForegroundColor = 'Green'
                        },
                        @{ NoNewline = $false }
                    )
                Set-CardanoTransactionInputs `
                    -Transaction $Transaction `
                    -Utxos $addressesUtxosSelection
                Clear-CardanoTransactionAllocations -Transaction $Transaction
            }
            
            'Set Allocation Recipient(s)' {
                $allocationRecipientsSelection = Get-FreeformInput `
                    -Instruction $(
                        "Specify 1 or more recipient addresses (e.g. <address1>,<address2>, ...)." +
                        "`nSeperate addresses using a comma."
                    ) `
                    -InputType 'string' `
                    -ValidationType TestCommand `
                    -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid'; ValueArg = 'Address' } `
                    -Delimited

                Clear-CardanoTransactionAllocations -Transaction $Transaction
                Initialize-CardanoTransactionAllocations `
                    -Transaction $Transaction `
                    -Recipients $allocationRecipientsSelection
            }

            'Set Change Recipient' {
                $_changeRecipient = Get-FreeformInput `
                    -Instruction "Specify 1 address to be the recipient of any change (unallocated tokens):" `
                    -InputType 'string' `
                    -ValidationType TestCommand `
                    -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid'; ValueArg = 'Address' }
                Initialize-CardanoTransactionChangeAllocation `
                    -Transaction $Transaction `
                    -Recipient $_changeRecipient
            }

            'Clear Change Recipient' {
                Reset-CardanoTransactionChangeAllocation -Transaction $Transaction
            }

            'Set Allocation' {
                $recipientOptionsSelection = Get-OptionSelection `
                    -Instruction 'Select a recipient:' `
                    -Options $(Get-CardanoTransactionAllocations -Transaction $Transaction).Recipient
    
                $tokenOptionsSelection = Get-OptionSelection `
                    -Instruction "Select one of the recipient's token allocations:" `
                    -Options $(Get-CardanoTransactionAllocations -Transaction $Transaction).Where({ 
                        $_.Recipient -eq $recipientOptionsSelection 
                    }).Value `
                    -OptionDisplayTemplate @(
                        @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
                        @{ Object = ')' },
                        @{ Object = ' | PolicyId: ' ; NoNewline = $true },
                        @{ Expression = '$($option.Value.PolicyId)'; ForegroundColor = 'Green' },
                        @{ Object = ' | Name: ' ; NoNewline = $true },
                        @{ Expression = '$($option.Value.Name)'; ForegroundColor = 'Green' },
                        @{ Object = ' | Quantity: ' ; NoNewline = $true },
                        @{ Expression = '$($option.Value.Quantity)'; ForegroundColor = 'Green' }
                        @{ NoNewline = $false }
                    )
                
                $quantityMaximum = $(
                    Get-CardanoTransactionTokenBalance `
                        -Transaction $Transaction `
                        -PolicyId $tokenOptionsSelection.PolicyId `
                        -Name $tokenOptionsSelection.Name
                    ).Quantity + 
                    $tokenOptionsSelection.Quantity
    
                $quantitySelection = Get-FreeformInput `
                    -Instruction $(
                        "Quantity available to allocate: $quantityMaximum" +
                        "`nSpecify a quantity to allocate."
                    ) `
                    -InputType 'Int64' `
                    -ValidationType InRange `
                    -ValidationParameters @{ 
                        Minimum = 0
                        Maximum = $quantityMaximum
                    }
                
                Set-CardanoTransactionAllocationValue `
                    -Transaction $Transaction `
                    -Recipient $recipientOptionsSelection `
                    -PolicyId $tokenOptionsSelection.PolicyId `
                    -Name $tokenOptionsSelection.Name `
                    -Quantity $quantitySelection
            }

            'Set Fee Allocation' {
                $recipientOptionsSelection = Get-OptionSelection `
                    -Instruction 'Select a recipient:' `
                    -Options $(
                        Get-CardanoTransactionAllocations -Transaction $Transaction -ChangeAllocation
                    ).Recipient
                
                $feePercentageMaximum = $(
                    Get-CardanoTransactionUnallocatedFeePercentage `
                        -Transaction $Transaction `
                        -Transform Int `
                    ) + $(
                    Get-CardanoTransactionAllocationFeePercentage `
                        -Transaction $Transaction `
                        -Recipient $recipientOptionsSelection `
                        -Transform Int
                    )

                $feePercentageSelection = Get-FreeformInput `
                    -Instruction $(
                        "Percentage available to allocate: $feePercentageMaximum" +
                        "`nSpecify a percentage of the fee to allocate."
                    ) `
                    -InputType 'int' `
                    -ValidationType InRange `
                    -ValidationParameters @{ 
                        Minimum = 0
                        Maximum = $feePercentageMaximum
                    }

                Set-CardanoTransactionAllocationFeePercentage `
                    -Transaction $Transaction `
                    -Recipient $recipientOptionsSelection `
                    -FeePercentage $feePercentageSelection
            }

            'Sign'{
                if(-not $SigningKeys){
                    $witnessQuantity = Get-CardanoTransactionWitnessQuantity -Transaction $Transaction
                    $SigningKeys = @()
                    (1..$witnessQuantity).ForEach({
                        $SigningKeys += Get-FreeformInput `
                            -Instruction $(
                                "Witness $($_): Specify the signing key string (e.g. <key>)" +
                                " or signing key file path (e.g. </path/to/key.skey>)."
                            ) `
                            -InputType 'object' `
                            -TransformCommand 'ConvertTo-CardanoKeySecureStringList' `
                            -TransformValueArg 'Objects' `
                            -ValidationType TestCommand `
                            -ValidationParameters @{ Command = 'Test-CardanoSigningKeyIsValid'; ValueArg = 'Key' } `
                            -Delimited `
                            -Sensitive
                    })
                }

                Set-CardanoTransactionSigned `
                    -Transaction $Transaction `
                    -SigningKeys $SigningKeys
            }

            'Submit'{
                $submitSelection = Get-OptionSelection `
                    -Instruction 'Confirm transaction should be submitted:' `
                    -Options @('Continue Editing','Submit')
                
                if($submitSelection -eq 'Submit'){
                    Submit-CardanoTransaction -Transaction $Transaction
                    $interactionComplete = $true
                }
            }

            'Done Editing'{
                $interactionComplete = $true
            }
        }
    }
    until($interactionComplete)
    Format-CardanoTransactionSummary -Transaction $Transaction
}
