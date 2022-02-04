function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        $WorkingDir,
        $Addresses,
        [CardanoUtxoList]$Utxos
    )
    try{
        function Get-AvailableTokens($Utxos) {
            $availableTokens = @{}
            $Utxos.Utxos.ForEach({ 
                $_.Value.ForEach({ 
                    $availableTokens["$($_.PolicyId).$($_.Name)"] = [CardanoToken]::new($_.PolicyId, $_.Name, 0) 
                }) 
            })
            $availableTokens.GetEnumerator().ForEach({ 
                $token = $_.Value
                $token.Quantity = $(
                    $Utxos.Utxos.Value.Where({ 
                        $_.PolicyId -eq $token.PolicyId -and 
                        $_.Name -eq $token.Name 
                    }).Quantity | Measure-Object -Sum
                ).Sum
            })
            $availableTokens = $availableTokens.GetEnumerator().ForEach({ $_.Value })
            return $availableTokens
        }

        function Get-UnallocatedTokens ($Utxos, $Allocations) {
            $allAvailableTokens = Get-AvailableTokens $Utxos
            $allocatedTokens = $Allocations.GetEnumerator().ForEach({ $_.Value })
            $unallocatedTokens = $allAvailableTokens.ForEach({
                $availableToken = $_
                $allocatedQuantity = $(
                    $allocatedTokens.Where({ 
                        $_.PolicyId -eq $availableToken.PolicyId -and
                        $_.Name -eq $availableToken.Name
                    }).Quantity | Measure-Object -Sum
                ).Sum
                $availableToken.Quantity = $availableToken.Quantity - $allocatedQuantity
                if($availableToken.Quantity){
                    $availableToken
                }
            })
            return $unallocatedTokens
        }
        
        function Write-AllocatedTokens ($Allocations) {
            $Allocations.GetEnumerator() | 
            Select-Object Key, Value -ExpandProperty Value | 
            Format-Table PolicyId, Name, Quantity, @{Label='Recipient';Expression={$_.Key}} | 
            Out-String |
            Write-Host -ForegroundColor Cyan
        }
        
        function Write-UnallocatedTokens($Utxos, $Allocations) {
            $unallocatedTokens = Get-UnallocatedTokens $Utxos $Allocations
            $unallocatedTokens | Format-Table PolicyId, Name, Quantity | 
            Out-String | 
            Write-Host -ForegroundColor Green
        }

        function Write-TransactionFee {
            Write-Host $(Get-Random -Maximum 10)
        }

        $addressPattern = '^(addr1|stake1|addr_test1|stake_test1)[a-z0-9]+$|^(Ae2|DdzFF|37bt)[a-zA-Z0-9]+$'
        if([string]::IsNullOrWhiteSpace($Utxos)){
            if([string]::IsNullOrWhiteSpace($Addresses)){
                $Addresses = Get-FreeformInput `
                    -Instruction $(
                        "Specify 1 or more addresses holding UTXOs (e.g. <address1>,<address2>, ...)." +
                        "`nSeperate addresses using a comma."
                    ) `
                    -InputType 'string' `
                    -ValidationType MatchPattern `
                    -ValidationParameters @{ Pattern = $addressPattern } `
                    -Delimited
            }

            $addressesUtxos = New-Object CardanoUtxoList
            $Addresses.ForEach({
                $addressUtxos = Get-CardanoAddressUtxos -Address $_ -WorkingDir $WorkingDir
                $addressUtxos.Utxos.ForEach({
                    $addressesUtxos.AddUtxo($_)
                })
            })

            $utxoOptionsSelection = Get-OptionSelection `
                -MultipleChoice `
                -Instruction $(
                    "Select 1 or more UTXOs to spend by specifying number associated to UTXO (e.g. 1,3, ...)." +
                    "`nSeperate numbers using a comma.`n"
                ) `
                -Options $addressesUtxos.Utxos `
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

            $Utxos = New-Object CardanoUtxoList
            $utxoOptionsSelection.ForEach({ $Utxos.AddUtxo($_) })
        }

        if([string]::IsNullOrWhiteSpace($Allocations)){
            if([string]::IsNullOrWhiteSpace($Recipients)){
                $Recipients = Get-FreeformInput `
                    -Instruction $(
                        "Specify 1 or more recipient addresses (e.g. <address1>,<address2>, ...)." +
                        "`nSeperate addresses using a comma."
                    ) `
                    -InputType 'string' `
                    -ValidationType MatchPattern `
                    -ValidationParameters @{ Pattern = $addressPattern } `
                    -Delimited
            }

            $Allocations = [ordered]@{}
            $($Recipients).ForEach({
                $recipient = $_
                $Allocations.$recipient = [System.Collections.ArrayList]@()
                $(Get-AvailableTokens($Utxos)).ForEach({
                    $token = $_
                    $Allocations.$recipient.Add([CardanoToken]::new($token.PolicyId,$token.Name,0)) | Out-Null
                })
            })

            do{
                $allocationActionsComplete = $false
                Write-Host "Current allocated tokens:"; Write-AllocatedTokens $Allocations                
                Write-Host "Current transaction fee: " -NoNewline; Write-TransactionFee
                Write-Host "Current unallocated tokens:"; Write-UnallocatedTokens $Utxos $Allocations
                Write-Host "NOTE: Any unallocated tokens will be automatically allocated as change for a recipient that will need to be specified"
                $allocationActionSelection = Get-OptionSelection `
                    -Instruction 'Select an allocation action, or specify finished allocating:' `
                    -Options @('Allocate token', 'Deallocate token', 'Finished allocating')

                $allocationActions = @{ 
                    'Allocate token' = @{ 
                        Label = 'allocate'
                        RecipientOptions = $Recipients
                        TokenOptions = {$(Get-UnallocatedTokens $Utxos $Allocations)}
                        Action = {$args[0]+$args[1]} 
                    } 
                    'Deallocate token' = @{ 
                        Label = 'deallocate'
                        RecipientOptions = $Allocations.Keys
                        TokenOptions = {$Allocations[$recipientOptionsSelection]}
                        Action = {$args[0]-$args[1]} 
                    } 
                }
                switch($allocationActionSelection){
                    {$_ -in 'Allocate token','Deallocate token'} { 
                        $recipientOptionsSelection = Get-OptionSelection `
                            -Instruction 'Select a recipient:' `
                            -Options $allocationActions[$_].RecipientOptions

                        $tokenOptionsSelection = Get-OptionSelection `
                            -Instruction 'Select a token:' `
                            -Options $(& $allocationActions[$_].TokenOptions) `
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

                        $quantitySelection = Get-FreeformInput `
                            -Instruction "Select a quantity to $($allocationActions[$_].Label):" `
                            -InputType 'int' `
                            -ValidationType InRange `
                            -ValidationParameters @{ Minimum = 0; Maximum = $tokenOptionsSelection.Quantity }
                        
                        $allocation = $(
                            $Allocations[$recipientOptionsSelection].Where({ 
                            $_.PolicyId -eq $tokenOptionsSelection.PolicyId -and 
                            $_.Name -eq $tokenOptionsSelection.Name})
                        )

                        $allocation.Quantity = & $allocationActions[$_].Action $allocation.Quantity $quantitySelection
                    }
                    'Finished allocating' { $allocationActionsComplete = $true }
                    default { Write-Host "Invalid Selection: $_" -ForegroundColor Red }
                }
            }
            until($allocationActionsComplete)
        }
    }
    catch{
        throw $_
    }
}