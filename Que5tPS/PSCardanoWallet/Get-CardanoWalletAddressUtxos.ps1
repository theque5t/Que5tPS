function Get-CardanoWalletAddressUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ArgumentCompleter({ $(Get-CardanoWallets).Name })]
        [ValidateScript({ $_ -in $(Get-CardanoWallets).Name },
         ErrorMessage = (
         "The wallet, {0}, " + 
         "is not valid per the following script: {1}"))]
        $Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [ArgumentCompleter({ 
            param($Command, $Param, $Input, $AST, $ParamState)
            $(Get-CardanoWalletAddressFiles $ParamState.Name).Name 
        })]
        [ValidateScript({ 
            $_ -in $(Get-CardanoWalletAddressFiles $PSBoundParameters.Name).Name 
        },
         ErrorMessage = (
         "The wallet address file, {0}, " +
         "is not valid per the following script: {1}"))]
        $File
    )
    process{
        try{
            Assert-CardanoWalletSessionIsOpen
            Write-VerboseLog "Getting wallet address utxo..."

            $walletPath = $(Get-CardanoWallet $Name).FullName
            $walletTemp = "$walletPath\.temp"
            $outputFile = "$walletTemp\queryUtxoOutput-$($(New-Guid).Guid).json"
            $_args = @(
                'query','utxo'
                '--address', $(Get-CardanoWalletAddress $Name $File)
                '--out-file', $outputFile
                $env:CARDANO_CLI_NETWORK_ARG
                $env:CARDANO_CLI_NETWORK_ARG_VALUE
            )
            Invoke-CardanoCLI @_args
            $queryOutput = Get-Content $outputFile | ConvertFrom-Json -AsHashtable
            $utxos = [CardanoUtxoList]::new()
            $queryOutput.GetEnumerator().ForEach({
                Write-VerboseLog "Processing utxo $($_.Name)..."
                $utxo = [CardanoUtxo]::new($_.Name, $_.Value.address, $_.Value.data)
                $_.Value.value.GetEnumerator().ForEach({ 
                    Write-VerboseLog "Processing value $($_.Name)..."
                    $token = $_
                    switch ($token.value.GetType().Name) {
                        'Hashtable' { 
                            $tokenPolicyId = $token.Name
                            $token.Value.GetEnumerator().ForEach({
                                Write-VerboseLog "Processing token $($_.Name)..."
                                $utxo.AddToken(
                                    $tokenPolicyId, $_.Name, $_.Value
                                )
                            })
                        }
                        'Int64' { 
                            Write-VerboseLog "Processing token $($_.Name)..."
                            $utxo.AddToken(
                                $null, $token.Name, $token.Value
                            )
                        }
                    }
                })
                $utxos.AddUtxo($utxo)
            })

            return $utxos
        }
        finally{
            if($outputFile -and $(Test-Path $outputFile)){
                Remove-Item $outputFile
            }
        }
    }
}
