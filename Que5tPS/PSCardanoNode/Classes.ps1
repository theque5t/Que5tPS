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
    [datetime]$DateCreated
    [bool]$Signed
    [bool]$Submitted
    [System.IO.FileInfo]$File
    [CardanoUtxoList]$Inputs
    [CardanoTransactionOutput[]]$Outputs
    [Int64]$Fee

    CardanoTransaction($File, $Inputs, $Outputs){
        $this.DateCreated = Get-Date
        $this.Signed = $false
        $this.Submitted = $false
        if(-not (Test-Path $File)){ New-Item $File }
        $this.File = Get-Item $File
        $this.Inputs = $Inputs
        $this.Outputs = $Outputs
        $this.Fee = $this.GetMinimumFee()
    }

    [void]SetFile(){
        $templates = @{
            File = { '--out-file {0}' -f $args[0] }
            Input = {'--tx-in {0}#{1}' -f $args[0].TxHash, $args[0].Index}
            Output = { 
                $multipleTokens = $($args[0].Tokens.Where({ $_.Name -ne 'lovelace'})).Count
                '--tx-out {0}+{1}{2}{3}{4}' -f ( 
                    $args[0].Address,
                    $($args[0].Tokens.Where({ $_.Name -eq 'lovelace'})).Quantity,
                    $(if($multipleTokens){ '+"' }),
                    $($($args[0].Tokens.Where({ $_.Name -ne 'lovelace'})).ForEach({ 
                        "$($_.Quantity) $($_.PolicyId).$($_.Name)" 
                    }) -join ' + '),
                    $(if($multipleTokens){ '"' })
                )
            }
            Fee = { '--fee {0}' -f $args[0] }
        }
        $_args = [System.Collections.ArrayList]@()
        $_args.Add('transaction build-raw')
        $_args.Add($( & $templates.File $this.File.FullName ))
        $this.Inputs.Utxos.ForEach({ $_args.Add($(& $templates.Input $_)) })
        $this.Outputs.ForEach({ $_args.Add($( & $templates.Output $_ )) })
        $_args.Add($( & $templates.Fee $this.GetMinimumFee() ))
        # return $_args
        Invoke-CardanoCLI @_args
    }

    [Int64]GetMinimumFee(){
        [Int64]$MinimumFee = 0
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
}
