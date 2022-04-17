function Get-CardanoAddressUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory = $true)]
        $Address,
        [Parameter(Mandatory = $true)]
        $WorkingDir,
        [bool]$RemoveOutputFile = $true
    )
    process{
        try{
            Assert-CardanoNodeInSync -Network $Network
            Write-VerboseLog "Getting address utxo..."
            $socket = Get-CardanoNodeSocket -Network $Network
            $nodePath = Get-CardanoNodePath -Network $Network
            $outputFile = "$WorkingDir\queryUtxoOutput-$($(New-Guid).Guid).json"
            $networkArgs = Get-CardanoNodeNetworkArg -Network $Network
            $_args = @(
                'query','utxo'
                '--address', $Address
                '--out-file', $outputFile
                $networkArgs
            )
            Invoke-CardanoCLI `
                -Socket $socket `
                -Path $nodePath `
                -Arguments $_args
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
                                Add-CardanoUtxoToken -Utxo $utxo -Token $(
                                    New-CardanoToken `
                                        -PolicyId $tokenPolicyId `
                                        -Name $_.Name `
                                        -Quantity $_.Value
                                )
                            })
                        }
                        'Int64' { 
                            Write-VerboseLog "Processing token $($_.Name)..."
                            Add-CardanoUtxoToken -Utxo $utxo -Token $(
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
