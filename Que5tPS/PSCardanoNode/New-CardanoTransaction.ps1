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

        if([string]::IsNullOrWhiteSpace($Utxos)){
            if([string]::IsNullOrWhiteSpace($Addresses)){
                Write-Host "Specify 1 or more addresses holding UTXOs (e.g. <address1>,<address2>, ...)." `
                           "`nSeperate addresses using a comma." `
                           -ForegroundColor Yellow
                Write-Host "Input: " -ForegroundColor Yellow -NoNewline
                $Addresses = Read-Host
                Write-Host
                $Addresses = $Addresses.split(",").Trim()
            }

            $addressesUtxos = New-Object CardanoUtxoList
            $Addresses.ForEach({
                $addressUtxos = Get-CardanoAddressUtxos -Address $_ -WorkingDir $WorkingDir
                $addressUtxos.Utxos.ForEach({
                    $addressesUtxos.AddUtxo($_)
                })
            })

            $utxoOptions = [ordered]@{}
            $addressesUtxos.Utxos.ForEach({
                $key = "$($utxoOptions.Count + 1)"
                $utxoOptions.Add($key, $_)
            })

            Write-Host "Select 1 or more UTXOs to spend by specifying number associated to UTXO (e.g. 1,3, ...)." `
                       "`nSeperate numbers using a comma.`n" `
                       -ForegroundColor Yellow
            $utxoOptions.GetEnumerator().ForEach({
                Write-Host "$($_.Key)" -ForegroundColor Cyan -NoNewline; Write-Host ')'
                Write-Host
                Write-Host " | UTXO Id: " -NoNewline; Write-Host $($_.Value.Id) -ForegroundColor Green
                Write-Host " | UTXO Data: " -NoNewline; Write-Host $($_.Value.Data) -ForegroundColor Green
                Write-Host " | UTXO Holding Address: " -NoNewline; Write-Host $($_.Value.Address) -ForegroundColor Green
                Write-Host " | UTXO Tokens:"
                $($_.Value | 
                  Select-Object * -ExpandProperty Value | 
                  Format-List $(
                    'PolicyId'
                    'Name'
                    'Quantity'
                  ) | Out-String -Stream
                ).ForEach({
                    Write-Host " |   " -NoNewline; Write-Host $_ -ForegroundColor Green
                })
                Write-Host
            })
            Write-Host "Input: " -ForegroundColor Yellow -NoNewline
            $utxoOptionsSelection = Read-Host
            Write-Host

            $utxoOptionsSelection = $utxoOptionsSelection.split(",").Trim()
            $Utxos = New-Object CardanoUtxoList
            $utxoOptionsSelection.ForEach({
                if($utxoOptions.Contains($_)){
                    $utxo = $utxoOptions.$_
                    $Utxos.AddUtxo($utxo)
                }
            })
        }

        if([string]::IsNullOrWhiteSpace($Allocations)){
            if([string]::IsNullOrWhiteSpace($Recipients)){
                Write-Host "Specify 1 or more recipient addresses (e.g. <address1>,<address2>, ...)." `
                           "`nSeperate addresses using a comma." `
                           -ForegroundColor Yellow
                Write-Host "Input: " -ForegroundColor Yellow -NoNewline
                $Recipients = Read-Host
                Write-Host
                $Recipients = $Recipients.split(",").Trim()
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
                Write-Host "Select an allocation action, or specify finished allocating"
                Write-Host "1 - Allocate token"
                Write-Host "2 - Deallocate token"
                Write-Host "3 - Finished allocating"
                Write-Host "Input: " -NoNewline
                $selection = Read-Host 
                switch($selection){
                    1 { 

                        # $Allocations = @{
                        #     "addr_test3" = [CardanoToken]::new('','lovelace',5), [CardanoToken]::new('4fc16c9','factory',1)
                        #     "addr_test4" = [CardanoToken]::new('','lovelace',5)
                        # }
                        # $Recipients = [ordered]@{"1" = "addr1"; "2" = "addr2"; "3" = "addr3"}
                        # $Tokens = [ordered]@{ "1" = @{ Token = "lovelace"; Quantity = 10000000 }; "2" = @{ Token = "factory"; Quantity = 1 } }

                        # RECIPIENT OPTIONS
                        $recipientOptions = [ordered]@{}
                        $Recipients.ForEach({
                            $key = "$($recipientOptions.Count + 1)"
                            $recipientOptions.Add($key, $_)
                        })
                        Write-Host "Select a recipient:"
                        $recipientOptions.GetEnumerator().ForEach({
                            Write-Host "$($_.Key)) $($_.Value)"
                        })
                        Write-Host "Input: " -NoNewline
                        $recipientOptionsSelection = Read-Host
                        $recipientOptionsSelection = $recipientOptions[$recipientOptionsSelection.Trim()]
                        
                        # TOKEN OPTIONS
                        $tokenOptions = [ordered]@{}
                        $(Get-UnallocatedTokens $Utxos $Allocations).ForEach({
                            $key = "$($tokenOptions.Count + 1)"
                            $tokenOptions.Add($key, $_)
                        })
                        Write-Host "Select a token:"
                        $tokenOptions.GetEnumerator().ForEach({
                            Write-Host "$($_.Key))"
                            $_.Value | Select-Object * | Format-Table | Out-String | Write-Host
                        })
                        Write-Host "Input: " -NoNewline
                        $tokenOptionsSelection = Read-Host
                        $tokenOptionsSelection = $tokenOptions[$tokenOptionsSelection.Trim()]
                        
                        # QUANTITY OPTION
                        Write-Host "Select a quantity to allocate:"
                        Write-Host "Input: " -NoNewline
                        $quantity = Read-Host
                        
                        # UPDATE ALLOCATION
                        $($Allocations[$recipientOptionsSelection].Where({ 
                            $_.PolicyId -eq $tokenOptionsSelection.PolicyId -and 
                            $_.Name -eq $tokenOptionsSelection.Name
                        })).Quantity += $quantity                        
                    }
                    2 { 
                        # Write-Host "Select a recipient:"
                        # $Recipients.GetEnumerator().ForEach({
                        #     Write-Host "$($_.Key)) $($_.Value)"
                        # })
                        # Write-Host "Input: " -NoNewline
                        # $recipient = Read-Host
                        # $recipient = 
                        
                        # $tokenOptions = [ordered]@{}
                        # $(Get-UnallocatedTokens $Utxos $Allocations).ForEach({
                        #     $key = "$($tokenOptions.Count + 1)"
                        #     $tokenOptions.Add($key, $_)
                        # })
                        # Write-Host "Select a token:"
                        # $tokenOptions.GetEnumerator().ForEach({
                        #     Write-Host "$($_.Key))"
                        #     $_.Value | Select-Object * | Format-Table | Out-String | Write-Host
                        # })
                        # Write-Host "Input: " -NoNewline
                        # $token = Read-Host
                        
                        # Write-Host "Select a quantity to allocate:"
                        # Write-Host "Input: " -NoNewline
                        # $quantity = Read-Host
                        # $($Tokens[$token].Quantity + $quantity)
                        
                        # Write-Output "Allocated $quantity of $($Tokens[$token].Token) to $($Recipients[$recipient])"
                        # Write-Output "$($Tokens[$token].Quantity - $quantity) $($Tokens[$token].Token) left..."
                        # $allocationAction = 'allocate'
                    }
                    3 { $allocationActionsComplete = $true }
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