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
    [CardanoToken[]]$Tokens

    CardanoTransactionOutput($Address, $Tokens){
        $this.Address = $Address
        $this.Tokens = $Tokens
    }
}

class CardanoTransaction {
    # [bool]$Signed
    # [bool]$Submitted
    $StateFile
    $TxBodyFile
    $TxBodyFileContent
    $TxBodyFileObject
    $TxBodyFileView
    $TxBodyFileViewObject

    [CardanoUtxoList]$Inputs
    [CardanoTransactionOutput[]]$Outputs
    [Int64]$Fee

    CardanoTransaction([System.IO.DirectoryInfo]$WorkingDir, [string]$Name){
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
            
            $_inputs = New-Object CardanoUtxoList
            $state.Inputs.Utxos.GetEnumerator().ForEach({
                $utxo = [CardanoUtxo]::new($_.Id, $_.Address, $_.Data)
                $_.Value.GetEnumerator().ForEach({
                    $utxo.AddToken($_.PolicyId, $_.Name, $_.Quantity)
                })
                $_inputs.AddUtxo($utxo)
            })
            $this.Inputs = $_inputs
            
            $_outputs = [System.Collections.ArrayList]@()
            $state.Outputs.GetEnumerator().ForEach({
                $_tokens = [System.Collections.ArrayList]@()
                $_.Tokens.GetEnumerator().ForEach({
                    $_tokens.Add([CardanoToken]::new($_.PolicyId, $_.Name, $_.Quantity))
                })
                $_outputs.Add([CardanoTransactionOutput]::new($_.Address, $_tokens))
            })
            $this.Outputs = $_outputs

            $this.Fee = $this.GetMinimumFee()
            $this.RefreshTxBody()
        }
    }

    [void]ExportState(){
        [ordered]@{ 
            Inputs = $this.Inputs
            Outputs = $this.Outputs
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

    [void]ExportTxBody($Fee){
        $templates = @{
            Input = {'{0}#{1}' -f $args[0].TxHash, $args[0].Index}
            Output = { 
                $multipleTokens = $($args[0].Tokens.Where({ $_.Name -ne 'lovelace'})).Count
                '{0}+{1}{2}{3}{4}' -f ( 
                    $args[0].Address,
                    $($args[0].Tokens.Where({ $_.Name -eq 'lovelace'})).Quantity,
                    $(if($multipleTokens){ '+"' }),
                    $($($args[0].Tokens.Where({ $_.Name -ne 'lovelace'})).ForEach({ 
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
        $this.Inputs.Utxos.ForEach({ 
            $_args.Add('--tx-in')
            $_args.Add($(& $templates.Input $_))
        })
        $this.Outputs.ForEach({ 
            $_args.Add('--tx-out')
            $_args.Add($( & $templates.Output $_ ))
        })

        $_args.Add('--fee')
        $_args.Add($Fee)
        Invoke-CardanoCLI @_args
    }

    [void]ExportTxBody(){
        $this.ExportTxBody($this.Fee)
    }

    # Object state takes precedence
    # Export tx body using object state and then import
    [void]RefreshTxBody(){
        $this.ExportTxBody()
        $this.ImportTxBody()
    }

    [void]AddInput([CardanoUtxo]$Utxo){ 
        $this.Inputs.AddUtxo($Utxo)
    }

    [void]RemoveInput([string]$Id){
        $this.Inputs.RemoveUtxo($Id)
    }

    [void]AddOutput([CardanoTransactionOutput]$Output){
        $this.Outputs += $Output
    }

    [void]RemoveOutput([string]$Address){ 
        $this.Outputs = $this.Outputs.Where({
            $_.Address -ne $Address
        })
    }

    [string[]]GetWitnesses(){
        return $this.Inputs.Utxos.ForEach({ $_.Address }) | Sort-Object | Get-Unique
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

class CardanoUtxoList {
    [CardanoUtxo[]]$Utxos

    [void]AddUtxo([CardanoUtxo]$_utxo){
        $this.Utxos += $_utxo
    }

    [void]RemoveUtxo($Id){
        $this.Utxos = $this.Utxos.Where({ 
            $_.Id -ne $Id 
        })
    }
}
