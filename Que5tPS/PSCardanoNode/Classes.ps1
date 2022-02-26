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

class CardanoTransactionAllocation {
    [string]$Recipient
    [CardanoToken[]]$Value

    CardanoTransactionAllocation($Recipient, $Value){
        Assert-CardanoAddressIsValid $Recipient
        $this.Recipient = $Recipient
        $this.Value = $Value
    }
}

class CardanoTransactionOutput {
    [string]$Address
    [CardanoToken[]]$Value

    CardanoTransactionOutput([CardanoTransactionAllocation]$Allocation){
        $this.Address = $Allocation.Recipient
        $this.Value = $Allocation.Value.Where({ $_.Quantity -gt 0 })
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
    [CardanoTransactionAllocation[]]$Allocations
    [string]$ChangeRecipient

    CardanoTransaction([System.IO.DirectoryInfo]$WorkingDir, [string]$Name){
        $this.WorkingDir = $WorkingDir
        $this.StateFile = "$($WorkingDir.FullName)\$Name.state.yaml"
        $this.TxBodyFile = "$($WorkingDir.FullName)\$Name.tx.json"
        if(-not (Test-Path $this.StateFile)){ New-Item $this.StateFile }
        if(-not (Test-Path $this.TxBodyFile)){ New-Item $this.TxBodyFile }
        $this.ImportState()
        $this.RefreshState()
    }

    [void]ImportState(){
        $this.StateFile = Get-Item $this.StateFile
        $this.TxBodyFile = Get-Item $this.TxBodyFile
        if($this.StateFile.Length -gt 0){
            $state = Get-Content $this.StateFile | ConvertFrom-Yaml
            $state.Inputs = [array]$state.Inputs
            $state.Allocations = [array]$state.Allocations
            
            $this.Inputs = [CardanoUtxo[]]@()
            $state.Inputs.ForEach({
                $utxo = [CardanoUtxo]::new($_.Id, $_.Address, $_.Data)
                $_.Value.GetEnumerator().ForEach({
                    $utxo.AddToken($_.PolicyId, $_.Name, $_.Quantity)
                })
                $this.AddInput($utxo)
            })
            
            $this.Allocations = [CardanoTransactionAllocation[]]@()
            $state.Allocations.ForEach({
                $_tokens = [CardanoToken[]]@()
                $_.Value.GetEnumerator().ForEach({
                    $_tokens += ([CardanoToken]::new($_.PolicyId, $_.Name, $_.Quantity))
                })
                $this.AddAllocation([CardanoTransactionAllocation]::new($_.Recipient, $_tokens))
            })

            $this.ChangeRecipient = $state.ChangeRecipient

            $this.RefreshTxBody()
        }
    }

    [void]ExportState(){
        [ordered]@{ 
            Inputs = $this.Inputs
            Allocations = $this.Allocations
            ChangeRecipient = $this.ChangeRecipient
        } | ConvertTo-Yaml -OutFile $this.StateFile -Force
    }

    # Object state takes precedence
    # Overwrite state file with object state and then import
    [void]RefreshState(){
        $this.ExportState()
        $this.ImportState()
    }

    [void]ImportTxBody(){
        $this.TxBodyFile = Get-Item $this.TxBodyFile
        $this.TxBodyFileContent = Get-Content $this.TxBodyFile
        $this.TxBodyFileObject = if($this.TxBodyFileContent){ $this.TxBodyFileContent | ConvertFrom-Json  }
        $this.TxBodyFileView = if($this.TxBodyFileContent){ 
            Invoke-CardanoCLI transaction view --tx-body-file $this.TxBodyFile
        }
        $this.TxBodyFileViewObject = if($this.TxBodyFileView) { $this.TxBodyFileView | ConvertFrom-Yaml }
    }

    # [System.Collections.ArrayList]ExportTxBody($Fee){
    #     $_args = [System.Collections.ArrayList]@()
    [void]ExportTxBody([Int64]$Fee){
        if($this.HasInputs()){
            Assert-CardanoNodeInSync
            $templates = @{
                Input = {'{0}#{1}' -f $args[0].TxHash, $args[0].Index}
                Output = { 
                    $multipleTokens = $($args[0].Value.Where({ $_.Name -ne 'lovelace'})).Count
                    '{0}+{1}{2}{3}{4}' -f ( 
                        $args[0].Address,
                        $($args[0].Value.Where({ $_.Name -eq 'lovelace'})).Quantity,
                        $(if($multipleTokens){ '+"' }),
                        $($($args[0].Value.Where({ $_.Name -ne 'lovelace'})).ForEach({ 
                            "$($_.Quantity) $($_.PolicyId).$($_.Name)" 
                        }) -join ' + '),
                        $(if($multipleTokens){ '"' })
                    )
                }
            }
            $_args = [System.Collections.ArrayList]@()
            $_args.Add('transaction')
            $_args.Add('build-raw')
            $_args.Add('--out-file')
            $_args.Add($this.TxBodyFile.FullName)
            $this.GetInputs().ForEach({ 
                $_args.Add('--tx-in')
                $_args.Add($(& $templates.Input $_))
            })
            $this.GetOutputs().ForEach({ 
                $_args.Add('--tx-out')
                $_args.Add($( & $templates.Output $_ ))
            })
    
            $_args.Add('--fee')
            $_args.Add($Fee)
            
            Invoke-CardanoCLI @_args
        }
        else{ New-Item $this.TxBodyFile -Force }
        # return $_args
    }

    [void]ExportTxBody(){
        $this.ExportTxBody(0)
    }

    # Object state takes precedence
    # Export tx body using object state and then import
    [void]RefreshTxBody(){
        $this.ExportTxBody()
        $this.ImportTxBody()
    }

    [void] AddInput([CardanoUtxo]$Utxo){ 
        $this.Inputs += $Utxo
    }

    [void] RemoveInput([string]$Id){
        $this.Inputs = $this.Inputs.Where({
            $_.Id -ne $Id
        })
    }

    [void] AddAllocation([CardanoTransactionAllocation]$Allocation){
        $this.Allocations += $Allocation
    }

    [void] RemoveAllocation([string]$Recipient){ 
        $this.Allocations = $this.Allocations.Where({
            $_.Recipient -ne $Recipient
        })
    }

    [void] FormatTransactionSummary(){
        Format-CardanoTransactionSummary $this
    }

    [void] Minting(){
        Write-Host TODO
    }

    [CardanoUtxo[]]GetInputs(){
        return $this.Inputs
    }

    [CardanoToken[]] GetInputTokens(){
        return Merge-CardanoTokens $this.GetInputs().Value
    }

    [bool] HasInputs(){
        return [bool]$this.GetInputs().Count
    }

    [CardanoTransactionAllocation[]] GetAllocations(){
        return $this.Allocations
    }

    [CardanoToken[]] GetAllocatedTokens(){
        return Merge-CardanoTokens $this.GetAllocations().Value
    }

    [bool] HasAllocations(){
        return [bool]$this.GetAllocations().Count
    }

    [bool] HasAllocatedTokens(){
        return [bool]$this.GetAllocatedTokens().Count
    }

    # balance being the difference between input and output token quantities
    [CardanoToken[]] GetTokenBalances(){
        $allocatedTokens = $this.GetAllocatedTokens()
        $allocatedTokens.ForEach({ $_.Quantity = -$_.Quantity })
        return Merge-CardanoTokens $($this.GetInputTokens() + $allocatedTokens)
    }

    [CardanoToken[]] GetUnallocatedTokens(){
        return $this.GetTokenBalances().Where({ $_.Quantity -gt 0 })
    }

    [bool] HasUnallocatedTokens(){
        return [bool]$this.GetUnallocatedTokens().Count
    }

    [void] SetChangeRecipient([string]$Recipient){
        Assert-CardanoAddressIsValid $Recipient
        $this.ChangeRecipient = $Recipient
        $this.RefreshState()
    }

    [void] RemoveChangeRecipient(){
        $this.ChangeRecipient = ''
        $this.RefreshState()
    }

    [bool] HasChangeRecipient(){
        return [bool]$this.ChangeRecipient
    }

    [CardanoTransactionAllocation[]] GetChangeAllocation(){
        $changeAllocation = [CardanoTransactionAllocation[]]@()
        if($this.HasChangeRecipient() -and $this.HasUnallocatedTokens()){
            $changeAllocation += [CardanoTransactionAllocation]::new(
                $this.ChangeRecipient,
                $this.GetUnallocatedTokens()
            )
        }
        return $changeAllocation
    }

    [bool] HasChangeAllocation(){
        return [bool]$this.GetChangeAllocation().Count
    }

    [CardanoTransactionOutput[]]GetOutputs(){
        $outputs = [CardanoTransactionOutput[]]@()
        $($this.GetAllocations() + $this.GetChangeAllocation()).Where({
            $($_.Value.Quantity | Measure-Object -Sum).Sum -gt 0
        }).ForEach({
            $outputs += [CardanoTransactionOutput]::new($_)
        })
        return $outputs
    }

    [CardanoToken[]] GetOutputTokens(){
        return Merge-CardanoTokens $this.GetOutputs().Value
    }

    [bool] HasOutputs(){
        return [bool]$this.GetOutputs().Count
    }

    [string[]]GetWitnesses(){
        return $this.GetInputs().ForEach({ $_.Address }) | Sort-Object | Get-Unique
    }

    [System.Object]GetMinimumFee(){
        $MinimumFee = $null
        if($this.HasInputs()){
            Assert-CardanoNodeInSync
            $this.ExportTxBody(0)
            $_args = @(
                'transaction', 'calculate-min-fee'
                '--tx-body-file', $this.TxBodyFile.FullName
                '--tx-in-count', $this.GetInputs().Count
                '--tx-out-count', $this.GetOutputs().Count
                '--witness-count', $this.GetWitnesses().Count
                '--protocol-params-file', $env:CARDANO_NODE_PROTOCOL_PARAMETERS
                $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
            )
            $MinimumFee = Invoke-CardanoCLI @_args
            $MinimumFee = [Int64]$MinimumFee.TrimEnd(' Lovelace')
        }
        return $MinimumFee
    }

    [bool] IsBalanced(){ 
        $outputTokens = $this.GetOutputTokens()
        $outputTokens.ForEach({ $_.Quantity = -$_.Quantity })
        $inputOutputTokenDifference = $(Merge-CardanoTokens $(
            $this.GetInputTokens() + $outputTokens
        )).Where({ $_.Quantity -gt 0 }).Count
        return -not $inputOutputTokenDifference
    }

    [bool] IsSigned(){ return $false }
    [bool] IsSubmitted(){ return $false }

    [void] SetInteractively(){
        do{
            $interactionComplete = $false
            $this.FormatTransactionSummary()

            $actionSelection = Get-OptionSelection `
                -Instruction 'Select an option:' `
                -Options @(
                    'Set Inputs'
                    if($this.HasInputs()){ 
                        'Set Allocation Recipient(s)'
                        'Set Change Recipient' 
                    }
                    if($this.HasAllocations()){
                        'Set Allocation'
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
                    $this.Allocations = [CardanoTransactionAllocation[]]@()
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
        
                    $this.Allocations = [CardanoTransactionAllocation[]]@()
                    $_tokens = $this.GetInputTokens()
                    $_tokens.ForEach({ $_.Quantity = 0 })
                    $allocationRecipientsSelection.ForEach({
                        $this.AddAllocation([CardanoTransactionAllocation]::new($_, $_tokens))
                    })
                }

                'Set Allocation' {
                    $recipientOptionsSelection = Get-OptionSelection `
                        -Instruction 'Select a recipient:' `
                        -Options $($this.GetAllocations()).Recipient

                    $tokenOptionsSelection = Get-OptionSelection `
                        -Instruction "Select one of the recipient's token allocations:" `
                        -Options $this.GetAllocations().Where({ 
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
                    
                    $quantityMaximum = $this.GetTokenBalances().Where({
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
                    
                    $this.Allocations.Where({ 
                        $_.Recipient -eq $recipientOptionsSelection 
                    }).Where({
                        $_.Value.PolicyId -eq $tokenOptionsSelection.PolicyId -and
                        $_.Value.Name -eq $tokenOptionsSelection.Name
                    }).Value.Quantity = $quantitySelection
                }
                
                'Set Change Recipient' {
                    $_changeRecipient = Get-FreeformInput `
                        -Instruction "Specify 1 address to be the recipient of any change (unallocated tokens):" `
                        -InputType 'string' `
                        -ValidationType TestCommand `
                        -ValidationParameters @{ Command = 'Test-CardanoAddressIsValid' }
                    $this.SetChangeRecipient($_changeRecipient)
                }

                'Done Editing'{
                    $interactionComplete = $true
                }
            }
        }
        until($interactionComplete)
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
