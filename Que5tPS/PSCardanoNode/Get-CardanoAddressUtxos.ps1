function Get-CardanoAddressUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        $Address,
        [Parameter(Mandatory = $true, Position = 1)]
        $WorkingDir,
        [Parameter(Position = 2)]
        [bool]$RemoveOutputFile = $true
    )
    process{
        try{
            Assert-CardanoNodeInSync
            Write-VerboseLog "Getting address utxo..."

            $outputFile = "$WorkingDir\queryUtxoOutput-$($(New-Guid).Guid).json"
            $_args = @(
                'query','utxo'
                '--address', $Address
                '--out-file', $outputFile
                $env:CARDANO_CLI_NETWORK_ARG
                $env:CARDANO_CLI_NETWORK_ARG_VALUE
            )
            Invoke-CardanoCLI @_args
            $queryOutput = Get-Content $outputFile | ConvertFrom-Json -AsHashtable
            $utxos = [CardanoUtxo[]]@()
            $queryOutput.GetEnumerator().ForEach({
                Write-VerboseLog "Processing utxo $($_.Name)..."
                $utxo = New-CardanoUtxo `
                    -Id $_.Name `
                    -Address $_.Value.address `
                    -Data $_.Value.data
                $_.Value.value.GetEnumerator().ForEach({ 
                    Write-VerboseLog "Processing value $($_.Name)..."
                    $token = $_
                    switch ($token.value.GetType().Name) {
                        'Hashtable' { 
                            $tokenPolicyId = $token.Name
                            $token.Value.GetEnumerator().ForEach({
                                Write-VerboseLog "Processing token $($_.Name)..."
                                $utxo | Add-CardanoUtxoToken -Token $(
                                    New-CardanoToken `
                                        -PolicyId $tokenPolicyId `
                                        -Name $_.Name `
                                        -Quantity $_.Value
                                )
                            })
                        }
                        'Int64' { 
                            Write-VerboseLog "Processing token $($_.Name)..."
                            $utxo | Add-CardanoUtxoToken -Token $(
                                New-CardanoToken `
                                    -PolicyId '' `
                                    -Name $token.Name `
                                    -Quantity $token.Value
                            )
                        }
                    }
                })
                $utxos += $utxo
            })

            return $utxos
        }
        finally{
            if($outputFile -and $(Test-Path $outputFile) -and $RemoveOutputFile){
                Remove-Item $outputFile
            }
        }
    }
}
