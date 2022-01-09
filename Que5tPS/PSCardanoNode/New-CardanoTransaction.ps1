function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        $WorkingDir,
        $Addresses,
        [CardanoUtxoList]$Utxos
    )
    try{
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
                Write-Host " | From Address: " -NoNewline; Write-Host $($_.Value.Address) -ForegroundColor Green
                Write-Host " | Tokens:"
                $($_.Value | 
                  Select-Object * -ExpandProperty Value | 
                  Format-List $(
                    'PolicyId'
                    'Name'
                    'Quantity'
                    'Data'
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

        if([string]::IsNullOrWhiteSpace($Recipients)){
            Write-Host "Specify 1 or more recipient addresses (e.g. <address1>,<address2>, ...)." `
                       "`nSeperate addresses using a comma." `
                       -ForegroundColor Yellow
            Write-Host "Input: " -ForegroundColor Yellow -NoNewline
            $Recipients = Read-Host
            Write-Host
            $Recipients = $Recipients.split(",").Trim()
        }


        if([string]::IsNullOrWhiteSpace($Allocations)){
            # $unallocatedTokens = 
            # $Utxos

            do{
                $allocationsComplete = $false
                Write-Host "Current allocated tokens:"
                Write-Host "<allocated tokens table with recipient column>"
                Write-Host "Current transaction fee: <fee>"
                Write-Host "Current unallocated tokens:"
                Write-Host "<unallocated tokens table>"
                Write-Host "NOTE: Any unallocated tokens will be automatically allocated as change for a recipient that will need to be specified"
                Write-Host "Select an allocation action, or specify finished allocating"
                Write-Host "1 - Allocate token"
                Write-Host "2 - Deallocate token"
                Write-Host "3 - Finished allocating"
                Write-Host "Input: " -NoNewline
                $selection = Read-Host 
                switch($selection){
                    1 { Write-Host "Select a recipient:"
                        $Recipients.GetEnumerator().ForEach({
                            Write-Host "$($_.Key)) $($_.Value)"
                        })
                        Write-Host "Input: " -NoNewline
                        $recipient = Read-Host
                        
                        Write-Host "Select a token:"
                        $Tokens.GetEnumerator().ForEach({
                            Write-Host "$($_.Key))"
                            $_.Value | Select-Object * | Format-Table | Out-String | Write-Host
                        })
                        Write-Host "Input: " -NoNewline
                        $token = Read-Host
        
                        Write-Host "Select a quantity to allocate:"
                        Write-Host "Input: " -NoNewline
                        $quantity = Read-Host
        
                        Write-Output "Allocated $quantity of $($Tokens[$token].Token) to $($Recipients[$recipient])"
                        Write-Output "$($Tokens[$token].Quantity - $quantity) $($Tokens[$token].Token) left..."
                    }
                    2 { Write-Output "deallocating token..." }
                    3 { Write-Output "Finish..."; $allocationsComplete = $true }
                    default { Write-Host "Invalid Selection: $_" -ForegroundColor Red }
                }
            }
            until($allocationsComplete)
        }
        
    }
    catch{
        throw $_
    }
}