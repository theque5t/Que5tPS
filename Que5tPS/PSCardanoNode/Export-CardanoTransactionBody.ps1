function Export-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [CardanoTransaction]$Transaction,
        [Parameter(Mandatory = $true)]
        [Int64]$Fee = 0
    )
    if($($Transaction | Test-CardanoTransactionHasInputs)){
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
        $_args.Add($Transaction.BodyFile.FullName)
        
        $inputs = $Transaction | Get-CardanoTransactionInputs
        $inputs.ForEach({ 
            $_args.Add('--tx-in')
            $_args.Add($(& $templates.Input $_))
        })

        $outputs = $Transaction | Get-CardanoTransactionOutputs
        $outputs.ForEach({ 
            $_args.Add('--tx-out')
            $_args.Add($( & $templates.Output $_ ))
        })

        $_args.Add('--fee')
        $_args.Add($Fee)
        
        Invoke-CardanoCLI @_args
    }
    else{ New-Item $Transaction.BodyFile -Force }
}
