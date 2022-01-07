function New-CardanoTransaction {
    [CmdletBinding()]
    param(
        $WorkingDir,
        $Addresses,
        [CardanoUtxoList]$Utxos
    )
    try{
        # echo ""

        if([string]::IsNullOrWhiteSpace($Utxos)){
            if([string]::IsNullOrWhiteSpace($Addresses)){
                $Addresses = Read-Host "Specify 1 or more addresses holding UTXOs (e.g. <address1>,<address2>, ...). Seperate addresses using a comma`n"
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

            $utxoOptions.GetEnumerator().ForEach({
                Write-Host "`n$($_.Key)" -ForegroundColor Cyan -NoNewline && Write-Host ')'
                Write-Host "`n    Address: $($_.Value.Address)"
                $_.Value | Format-CardanoUtxoTableById | Out-String | Write-Host
            })
            $utxoOptionsSelection = Read-Host "Select 1 or more UTXOs to spend by specifying number associated to UTXO (e.g. 1,3, ...). Seperate numbers using a comma`n"
            $utxoOptionsSelection = $utxoOptionsSelection.split(",").Trim()
            $Utxos = New-Object CardanoUtxoList
            $utxoOptionsSelection.ForEach({
                if($utxoOptions.Contains($_)){
                    $utxo = $utxoOptions.$_
                    $Utxos.AddUtxo($utxo)
                }
            })
        }
        return $Utxos

    }
    catch{
        throw $_
    }
}