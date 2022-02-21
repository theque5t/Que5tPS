class CardanoToken {
    [string]$PolicyId
    [string]$Name
    [Int64]$Quantity

    CardanoToken($_policyId, $_name, $_quantity){
        $this.PolicyId = $_policyId
        $this.Name = $_name
        $this.Quantity = $_quantity
    }
}

class CardanoTransactionOutput {
    [string]$Address
    [CardanoToken[]]$Value

    CardanoTransactionOutput($Address, $Value){
        $this.Address = $Address
        $this.Value = $Value
    }
}

class CardanoTransaction {
    # [bool]$Signed
    # [bool]$Submitted
    [System.IO.DirectoryInfo]$WorkingDir
    $StateFile
    $TxBodyFile
    $TxBodyFileContent
    $TxBodyFileObject
    $TxBodyFileView
    $TxBodyFileViewObject

    [CardanoUtxo[]]$Inputs
    [CardanoTransactionOutput[]]$Outputs
    [string]$ChangeAddress
    [Int64]$Fee

    CardanoTransaction([System.IO.DirectoryInfo]$WorkingDir, [string]$Name){
        $this.WorkingDir = $WorkingDir
        # $this.StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
        # $this.TxBodyFile = "$($WorkingDir.FullName)\$Name.tx.json"
        # if(-not (Test-Path $this.StateFile)){ New-Item $this.StateFile }
        # if(-not (Test-Path $this.TxBodyFile)){ New-Item $this.TxBodyFile }
        # $this.ImportState()
    }

    # [void]ImportState(){
    #     $this.StateFile = Get-Item $this.StateFile
    #     $this.TxBodyFile = Get-Item $this.TxBodyFile
    #     if($this.StateFile.Length -gt 0){
    #         $state = Get-Content $this.StateFile | ConvertFrom-Yaml
            
    #         $_inputs = New-Object CardanoUtxoList
    #         $state.Inputs.Utxos.GetEnumerator().ForEach({
    #             $utxo = [CardanoUtxo]::new($_.Id, $_.Address, $_.Data)
    #             $_.Value.GetEnumerator().ForEach({
    #                 $utxo.AddToken($_.PolicyId, $_.Name, $_.Quantity)
    #             })
    #             $_inputs.AddUtxo($utxo)
    #         })
    #         $this.Inputs = $_inputs
            
    #         $_outputs = [System.Collections.ArrayList]@()
    #         $state.Outputs.GetEnumerator().ForEach({
    #             $_tokens = [System.Collections.ArrayList]@()
    #             $_.Tokens.GetEnumerator().ForEach({
    #                 $_tokens.Add([CardanoToken]::new($_.PolicyId, $_.Name, $_.Quantity))
    #             })
    #             $_outputs.Add([CardanoTransactionOutput]::new($_.Address, $_tokens))
    #         })
    #         $this.Outputs = $_outputs

    #         $this.Fee = $this.GetMinimumFee()
    #         $this.RefreshTxBody()
    #     }
    # }

    [void]ExportState(){
        [ordered]@{ 
            Inputs = $this.Inputs
            Outputs = $this.Outputs
            ChangeAddress = $this.ChangeAddress
        } | ConvertTo-Yaml -OutFile $this.StateFile -Force
    }

    # Object state takes precedence
    # Overwrite state file with object state and then import
    [void]RefreshState(){
    #     $this.ExportState()
    #     $this.ImportState()       
    }

    # [void]ImportTxBody(){
    #     $this.TxBodyFile = Get-Item $this.TxBodyFile
    #     $this.TxBodyFileContent = Get-Content $this.TxBodyFile
    #     $this.TxBodyFileObject = if($this.TxBodyFileContent){ $this.TxBodyFileContent | ConvertFrom-Json  }
    #     $this.TxBodyFileView = if($this.TxBodyFileContent){ 
    #         Invoke-CardanoCLI transaction view --tx-body-file $this.TxBodyFile
    #     }
    #     $this.TxBodyFileViewObject = if($this.TxBodyFileView) { $this.TxBodyFileView | ConvertFrom-Yaml }
    # }

    # [void]ExportTxBody($Fee){
    #     $templates = @{
    #         Input = {'{0}#{1}' -f $args[0].TxHash, $args[0].Index}
    #         Output = { 
    #             $multipleTokens = $($args[0].Tokens.Where({ $_.Name -ne 'lovelace'})).Count
    #             '{0}+{1}{2}{3}{4}' -f ( 
    #                 $args[0].Address,
    #                 $($args[0].Tokens.Where({ $_.Name -eq 'lovelace'})).Quantity,
    #                 $(if($multipleTokens){ '+"' }),
    #                 $($($args[0].Tokens.Where({ $_.Name -ne 'lovelace'})).ForEach({ 
    #                     "$($_.Quantity) $($_.PolicyId).$($_.Name)" 
    #                 }) -join ' + '),
    #                 $(if($multipleTokens){ '"' })
    #             )
    #         }
    #     }
    #     $_args = [System.Collections.ArrayList]@()
    #     $_args.Add('transaction')
    #     $_args.Add('build-raw')
    #     $_args.Add('--out-file')
    #     $_args.Add($this.TxBodyFile.FullName)
    #     $this.Inputs.Utxos.ForEach({ 
    #         $_args.Add('--tx-in')
    #         $_args.Add($(& $templates.Input $_))
    #     })
    #     $this.Outputs.ForEach({ 
    #         $_args.Add('--tx-out')
    #         $_args.Add($( & $templates.Output $_ ))
    #     })

    #     $_args.Add('--fee')
    #     $_args.Add($Fee)
    #     Invoke-CardanoCLI @_args
    # }

    # [void]ExportTxBody(){
    #     $this.ExportTxBody($this.Fee)
    # }

    # # Object state takes precedence
    # # Export tx body using object state and then import
    # [void]RefreshTxBody(){
    #     $this.ExportTxBody()
    #     $this.ImportTxBody()
    # }

    [void] AddInput([CardanoUtxo]$Utxo){ 
        $this.Inputs += $Utxo
    }

    [void] RemoveInput([string]$Id){
        $this.Inputs = $this.Inputs.Where({
            $_.Id -ne $Id
        })
    }

    [void] AddOutput([CardanoTransactionOutput]$Output){
        $this.Outputs += $Output
    }

    [void] RemoveOutput([string]$Address){ 
        $this.Outputs = $this.Outputs.Where({
            $_.Address -ne $Address
        })
    }

    [void] InteractivelySetInputs(){
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
            $addressesUtxos += Get-CardanoAddressUtxos -Address $_ -WorkingDir $this.WorkingDir
        })

        $this.Inputs = Get-OptionSelection `
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
    }

    [void] InteractivelySetChangeAddress(){
        $this.ChangeAddress = Get-FreeformInput `
            -Instruction "Specify 1 address to be the recipient of any change (unallocated tokens):" `
            -InputType 'string' `
            -ValidationType TestCommand `
            -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid' }
    }

    [void] PrintTransactionSummary(){
        $_allocationFormat = { 
            $args[0] | Select-Object Address, Value -ExpandProperty Value |
            Format-Table PolicyId, Name, Quantity, @{Label="Recipient";Expression={$_.Address}} |
            Out-String
        }
        $_labelPrefix = @{ Object = '  - '; NoNewline = $true }
        $_valuePrefix = @{ Object = '    '; NoNewline = $true }
        
        $_header = @(
            @{ Object = '=' * 97 }
            @{ Object = ' ' * 39 + 'TRANSACTION SUMMARY' + ' ' * 39 }
            @{ Object = '=' * 97 }
        )

        $_hasInputs = $this.HasInputs()
        $_inputsSection = @(
            @{ Object = '+--------+' + '-' * 87; ForegroundColor = 'DarkGray' }
            @{ Object = '| INPUTS | Description: Funds being spent'; ForegroundColor = 'DarkGray' }
            @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
            @{ Object = '' }
            @{ Prefix = $_labelPrefix;
                Object = 'UTXOs: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasInputs }
        )
        if($_hasInputs){
        $this.Inputs.ForEach({ 
            $_inputsSection += 
            @{ Object = '' },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true } 
               Object = 'Id: '; ForegroundColor = 'Yellow'; NoNewline = $true },
            @{ Object = $_.Id },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true } 
               Object = 'Data: '; ForegroundColor = 'Yellow'; NoNewline = $true },
            @{ Object = $_.Data },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true }
               Object = 'Holding Address: '; ForegroundColor = 'Yellow'; NoNewline = $true },
            @{ Object = $_.Address },
            @{ Prefix = @{ Object = '    | '; NoNewline = $true }
               Object = 'Tokens:'; ForegroundColor = 'Yellow' },
            @{ Prefix = @{ Object = '    |  '; NoNewline = $true }; 
               Object = $_.Value | Format-Table "PolicyId", "Name", "Quantity" | Out-String },
            @{ Object = '' }
        })}
        else{
            $_inputsSection += @{ Object = 'None' }
        }
        $_inputsSection += @{ NoNewLine = $_hasInputs }
        
        $_hasUnallocatedTokens = $this.HasUnallocatedTokens()
        $_hasAllocatedTokens = $this.HasAllocatedTokens()
        $_allocationsSection = @(
            @{ Object = '+---------+' + '-' * 86; ForegroundColor = 'DarkGray' }
            @{ Object = '| OUTPUTS | Description: Allocations of funds being spent'; ForegroundColor = 'DarkGray'  }    
            @{ Object = '+---------+'; ForegroundColor = 'DarkGray'  }
            @{ Object = '' }
            @{ Prefix = $_labelPrefix;
                Object = 'Unallocated Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasUnallocatedTokens }
            @{ Prefix = $_hasUnallocatedTokens ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
                Object = $_hasUnallocatedTokens ? $($this.GetUnallocatedTokens() | Out-String) : 'None' }
            @{ NoNewLine = $_hasUnallocatedTokens }
            @{ Prefix = $_labelPrefix;
                Object = 'Allocated Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasAllocatedTokens }
            @{ Prefix = $_hasAllocatedTokens ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
                Object = $_hasAllocatedTokens ? $(& $_allocationFormat $this.GetAllocations()) : 'None' }
            @{ NoNewLine = $_hasAllocatedTokens }
        )
        
        $_hasChangeAddress = $this.HasChangeAddress()
        $_changeSection = @(
            @{ Object = '+--------+' + '-' * 87; ForegroundColor = 'DarkGray' }
            @{ Object = '| CHANGE | Description: Allocation for any unallocated funds'; ForegroundColor = 'DarkGray' }    
            @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
            @{ Object = '' }
            @{ Prefix = $_labelPrefix;
               Object = 'Change Recipient: '; ForegroundColor = 'Yellow'; NoNewline = $true }
            @{ Object = $_hasChangeAddress ? $this.ChangeAddress : 'None - Not specified' }
            @{ Object = '' }
            @{ Prefix = $_labelPrefix;
               Object = 'Change Tokens: '; ForegroundColor = 'Yellow'; NoNewline = -not $_hasChangeAddress }
            @{ Prefix = $_hasChangeAddress ? $_valuePrefix : @{ Object = ''; NoNewline = $true }
               Object = $_hasChangeAddress ? $($this.GetChangeTokens() | Out-String) : 'None - Requires change recipient' }
            @{ NoNewLine = $_hasChangeAddress }
        )

        $_feeSection = @(
            @{ Object = '+------+' + '-' * 89; ForegroundColor = 'DarkGray' }
            @{ Object = '| FEES | Description: Costs associated to transaction'; ForegroundColor = 'DarkGray' }
            @{ Object = '+------+'; ForegroundColor = 'DarkGray' }
            @{ Object = '' }
            @{ Prefix = $_labelPrefix;
               Object = 'Minimum transaction fee: '; ForegroundColor = 'Yellow'; NoNewLine = $true}
            @{ Object = 0; }
            # @{ Object = $this.GetMinimumFee(); ForegroundColor = 'Cyan'}
            @{ Object = '' }
        )

        $_footer = @(
            @{ Object = '=' * 97 }
        )

        Write-HostBatch $(
            $_header + $_inputsSection + $_allocationsSection + $_changeSection + $_feeSection + $_footer
        )
    }

    # [CardanoTransactionOutput[]] InteractivelySetOutputs(){
    [void] InteractivelySetOutputs(){
        $outputAddressesSelection = Get-FreeformInput `
            -Instruction $(
                "Specify 1 or more recipient addresses (e.g. <address1>,<address2>, ...)." +
                "`nSeperate addresses using a comma."
            ) `
            -InputType 'string' `
            -ValidationType TestCommand `
            -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid' } `
            -Delimited

        # Do something with change
        # $this.InteractivelySetChangeAddress()

        $this.Outputs = [CardanoTransactionOutput[]]@()
        $_tokens = $this.GetInputTokens()
        $_tokens.ForEach({ $_.Quantity = 0 })
        $outputAddressesSelection.ForEach({
            $this.Outputs += [CardanoTransactionOutput]::new(
                $_, 
                $_tokens
            )
        })
        
        do{
            $allocationActionsComplete = $false
            $this.PrintTransactionSummary()

            $allocationActionSelection = Get-OptionSelection `
                -Instruction 'Select an option:' `
                -Options @('Set Allocation', 'Set Change Recipient', 'Finished Allocating')

            switch($allocationActionSelection){
                'Set Allocation' {
                    $recipientOptionsSelection = Get-OptionSelection `
                        -Instruction 'Select a recipient:' `
                        -Options $($this.GetAllocations()).Address

                    $tokenOptionsSelection = Get-OptionSelection `
                        -Instruction "Select one of the recipient's token allocations:" `
                        -Options $this.GetAllocations().Where({ 
                            $_.Address -eq $recipientOptionsSelection 
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
                    
                    $quantityMaximum = $this.GetUnallocatedTokens().Where({
                        $_.PolicyId -eq $tokenOptionsSelection.PolicyId -and
                        $_.Name -eq $tokenOptionsSelection.Name
                    }).Quantity + $tokenOptionsSelection.Quantity

                    $quantitySelection = Get-FreeformInput `
                        -Instruction $(
                            "Quantity available to allocate: $quantityMaximum" +
                            "`nSpecify a quantity to allocate."
                        ) `
                        -InputType 'int' `
                        -ValidationType InRange `
                        -ValidationParameters @{ 
                            Minimum = 0
                            Maximum = $quantityMaximum
                        }
                    
                    $this.Outputs.Where({ 
                        $_.Address -eq $recipientOptionsSelection 
                    }).Where({
                        $_.Value.PolicyId -eq $tokenOptionsSelection.PolicyId -and
                        $_.Value.Name -eq $tokenOptionsSelection.Name
                    }).Value.Quantity = $quantitySelection
                }
                
                'Set Change Recipient' {
                    $this.InteractivelySetChangeAddress()
                }

                'Finished Allocating'{
                    $allocationConfirmationSelectionOptions = [ordered]@{
                        Done = 'Done editing'
                        ContinueEditing = 'Continue editing'
                    }
                    $allocationConfirmationSelection = Get-OptionSelection `
                        -Instruction "Select an option:" `
                        -Options $allocationConfirmationSelectionOptions.Values
                    
                    $allocationActionsComplete = $(
                        $allocationConfirmationSelection -eq $allocationConfirmationSelectionOptions.Done
                    )
                }
            }
        }
        until($allocationActionsComplete)
    }

    [void] Minting(){
        Write-Host TODO
    }

    [CardanoToken[]] GetInputTokens(){
        return Merge-CardanoTokens $this.Inputs.Value
    }

    [bool] HasInputs(){
        return [bool]$this.Inputs.Count
    }

    [CardanoToken[]] GetOutputTokens(){
        return Merge-CardanoTokens $this.Outputs.Value
    }

    [bool] HasOutputs(){
        return [bool]$this.Outputs.Count
    }

    [CardanoToken[]] GetUnallocatedTokens(){
        $allocatedTokens = $this.GetAllocatedTokens()
        $allocatedTokens.ForEach({ $_.Quantity = -$_.Quantity })
        return Merge-CardanoTokens $($this.GetInputTokens() + $allocatedTokens)
    }

    [bool] HasUnallocatedTokens(){
        return [bool]$this.GetUnallocatedTokens().Where({ $_.Quantity -gt 0 })
    }

    [CardanoToken[]] GetAllocatedTokens(){
        return $this.GetOutputTokens()
    }

    [bool] HasAllocatedTokens(){
        return [bool]$this.GetAllocatedTokens().Where({ $_.Quantity -gt 0 })
    }

    [CardanoTransactionOutput[]] GetAllocations(){
        return $this.Outputs
    }

    [CardanoToken[]] GetChangeTokens(){
        return $this.GetUnallocatedTokens()
    }

    [void] SetChangeAddress($Address){
        Assert-CardanoAddressIsValid $Address
        $this.ChangeAddress = $Address
        $this.RefreshState()
    }

    [bool] HasChangeAddress(){
        return [bool]$this.ChangeAddress
    }

    [CardanoTransactionOutput[]] GetChangeAllocation(){
        $changeAllocation = [CardanoTransactionOutput[]]@()
        if($this.HasChangeAddress()){
            $changeAllocation += [CardanoTransactionOutput]::new(
                $this.ChangeAddress,
                $this.GetChangeTokens()
            )
        }
        return $changeAllocation
    }


    [string[]]GetWitnesses(){
        return $this.Inputs.ForEach({ $_.Address }) | Sort-Object | Get-Unique
    }

    [Int64]GetMinimumFee(){
        $this.ExportTxBody(0)
        $_args = @(
            'transaction', 'calculate-min-fee'
            '--tx-body-file', $this.TxBodyFile.FullName
            '--tx-in-count', $this.Inputs.Utxos.Count
            '--tx-out-count', $this.Outputs.Count
            '--witness-count', $($this.GetWitnesses()).Count
            '--protocol-params-file', $env:CARDANO_NODE_PROTOCOL_PARAMETERS
            $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
        )
        $MinimumFee = Invoke-CardanoCLI @_args
        $MinimumFee = [Int64]$MinimumFee.TrimEnd(' Lovelace')
        return $MinimumFee
    }
}

class CardanoUtxo {
    [string]$Id
    [string]$TxHash
    [Int64]$Index
    [CardanoToken[]]$Value
    [string]$Address
    [string]$Data

    CardanoUtxo($_id, $_address, $_data){
        $this.Id = $_id
        $this.TxHash = $_id.Split('#')[0]
        $this.Index = $_id.Split('#')[1]
        $this.Address = $_address
        $this.Data = $_data
    }

    [void]AddToken($_policyId, $_name, $_quantity){
        $this.Value += [CardanoToken]::new(
            $_policyId, $_name, $_quantity
        )
    }
}
