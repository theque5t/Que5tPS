function Export-CardanoTransactionBody {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [Int64]$Fee = 0
    )
    New-Item $Transaction.BodyFile -Force | Out-Null

    if($(Test-CardanoTransactionHasInputs -Transaction $Transaction)){
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
        [void]$_args.Add('transaction')
        [void]$_args.Add('build-raw')
        [void]$_args.Add('--out-file')
        [void]$_args.Add($Transaction.BodyFile.FullName)
        
        $inputs = Get-CardanoTransactionInputs -Transaction $Transaction
        $inputs.ForEach({ 
            [void]$_args.Add('--tx-in')
            [void]$_args.Add($(& $templates.Input $_))
        })

        $outputs = Get-CardanoTransactionOutputs -Transaction $Transaction
        $outputs.ForEach({ 
            [void]$_args.Add('--tx-out')
            [void]$_args.Add($( & $templates.Output $_ ))
        })

        [void]$_args.Add('--fee')
        [void]$_args.Add($Fee)
        
        Invoke-CardanoCLI @_args
    }
}
