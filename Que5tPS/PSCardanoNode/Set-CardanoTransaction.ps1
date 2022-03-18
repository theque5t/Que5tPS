function Set-CardanoTransaction {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Parameter(ParameterSetName = 'Interactive')]
        [switch]$Interactive,
        [Parameter(ParameterSetName = 'NonInteractive')]
        [CardanoUtxo[]]$Inputs,
        [Parameter(ParameterSetName = 'NonInteractive')]
        [CardanoTransactionAllocation[]]$Allocations,
        [Parameter(ParameterSetName = 'NonInteractive')]
        [ValidateScript({ Test-CardanoAddressIsValid -Address $_ })]
        [string]$ChangeRecipient
    )
    switch ($PsCmdlet.ParameterSetName) {
        'Interactive' { 
            do{
                $interactionComplete = $false
                Format-CardanoTransactionSummary -Transaction $Transaction
            
                $actionSelection = Get-OptionSelection `
                    -Instruction 'Select an option:' `
                    -Options @(
                        'Set Inputs'
                        if($(Test-CardanoTransactionHasInputs -Transaction $Transaction)){ 
                            'Set Allocation Recipient(s)'
                            'Set Change Recipient' 
                        }
                        if($(Test-CardanoTransactionHasAllocations -Transaction $Transaction)){
                            'Set Allocation'
                        }
                        if($(Test-CardanoTransactionHasFeeAllocations -Transaction $Transaction)){
                            'Set Fee Allocation'
                        }
                        if($(Test-CardanoTransactionHasChangeRecipient -Transaction $Transaction)){
                            'Remove Change Recipient'
                        }
                        'Done Editing'
                    )
            
                switch($actionSelection){
                    'Set Inputs' {
                        $addresses = Get-FreeformInput `
                            -Instruction $(
                                "Specify 1 or more addresses holding UTXOs (e.g. <address1>,<address2>, ...)." +
                                "`nSeperate addresses using a comma."
                            ) `
                            -InputType 'string' `
                            -ValidationType TestCommand `
                            -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid' } `
                            -Delimited
            
                        $addressesUtxos = [CardanoUtxo[]]@()
                        $addresses.ForEach({
                            $addressesUtxos += Get-CardanoAddressUtxos -Address $_ -WorkingDir $Transaction.WorkingDir
                        })
            
                        $Transaction.Inputs = Get-OptionSelection `
                            -MultipleChoice `
                            -Instruction $(
                                "Select 1 or more UTXOs to spend by specifying number associated to UTXO (e.g. 1,3, ...)." +
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
                        $Transaction.Allocations = [CardanoTransactionAllocation[]]@()
                    }
            
                    'Set Allocation Recipient(s)' {
                        $allocationRecipientsSelection = Get-FreeformInput `
                            -Instruction $(
                                "Specify 1 or more recipient addresses (e.g. <address1>,<address2>, ...)." +
                                "`nSeperate addresses using a comma."
                            ) `
                            -InputType 'string' `
                            -ValidationType TestCommand `
                            -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid' } `
                            -Delimited

                        Clear-CardanoTransactionAllocations -Transaction $Transaction
                        Initialize-CardanoTransactionAllocations -Transaction $Transaction `
                            -Recipients $allocationRecipientsSelection
                        Sync-CardanoTransactionFeeAllocations -Transaction $Transaction
                    }

                    'Set Change Recipient' {
                        $_changeRecipient = Get-FreeformInput `
                            -Instruction "Specify 1 address to be the recipient of any change (unallocated tokens):" `
                            -InputType 'string' `
                            -ValidationType TestCommand `
                            -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid' }
                        Set-CardanoTransactionChangeRecipient -Transaction $Transaction -Recipient $_changeRecipient
                        Sync-CardanoTransactionFeeAllocations -Transaction $Transaction
                    }

                    'Remove Change Recipient' {
                        Remove-CardanoTransactionChangeRecipient -Transaction $Transaction
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
                        
                        $quantityMaximum = $(Get-CardanoTransactionTokenBalances -Transaction $Transaction).Where({
                            $_.PolicyId -eq $tokenOptionsSelection.PolicyId -and
                            $_.Name -eq $tokenOptionsSelection.Name
                        }).Quantity + $tokenOptionsSelection.Quantity
            
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

                        # $percentageMaximum = Get-CardanoTransactionFeeAllocations
                        $percentageMaximum = 100

                        $percentageSelection = Get-FreeformInput `
                            -Instruction 'Specify a percentage of the fee to allocate.' `
                            -InputType 'Int64' `
                            -ValidationType InRange `
                            -ValidationParameters @{ 
                                Minimum = 0
                                Maximum = $percentageMaximum
                            }

                        Set-CardanoTransactionFeeAllocationPercentage -Transaction $Transaction `
                            -Recipient $recipientOptionsSelection `
                            -Percentage $percentageSelection
                    }

                    'Done Editing'{
                        $interactionComplete = $true
                    }
                }
            }
            until($interactionComplete)
         }
        'NonInteractive'{ Write-Warning 'TODO: Not implemented yet' }
    }
}
