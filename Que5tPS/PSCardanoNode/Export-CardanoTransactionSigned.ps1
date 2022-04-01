function Export-CardanoTransactionSigned{
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoTransaction]$Transaction,
        [securestring[]]$SigningKeys
    )
    New-Item $Transaction.SignedFile -Force | Out-Null
    if($SigningKeys){
        try{
            $signingKeyFiles = @()
            $SigningKeys.ForEach({
                $signingKeyFile = "$($Transaction.WorkingDir)\skey-$($(New-Guid).Guid).json"
                $signingKey = $_ | ConvertFrom-SecureString -AsPlainText
                Set-Content -Path $signingKeyFile -Value $signingKey
                $signingKeyFiles += $signingKeyFile
            })

            $_args = @(
                'transaction', 'sign'
                '--tx-body-file', $Transaction.BodyFile.FullName
                '--out-file', $Transaction.SignedFile.FullName
                $env:CARDANO_CLI_NETWORK_ARG, $env:CARDANO_CLI_NETWORK_ARG_VALUE
            )
            $signingKeyFiles.ForEach({
                [void]$_args.Add('--signing-key-file')
                [void]$_args.Add($_)
            })

            Invoke-CardanoCLI @_args
        }
        catch{
            Write-TerminatingError -Exception "Failed to sign transaction: $($Transaction.Name)"
        }
        finally{
            $signingKeyFiles.ForEach({ if(Test-Path $_){ Remove-Item $_ } })
        }
    }
}