function Format-CardanoMintContractSummary {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoMintContract]$MintContract
    )
    
    $_header = @(
        @{ Object = '=' * 129 }
        @{ Object = ' ' * 54 + 'MINT CONTRACT SUMMARY' + ' ' * 54 }
        @{ Object = '=' * 129 }
        @{ NoNewLine = $false }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = 'Name: '; ForegroundColor = 'Green'; NoNewline = $true }
        @{ Object = Get-CardanoMintContractName -MintContract $MintContract }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = 'Description: '; ForegroundColor = 'Green'; NoNewline = $true }
        @{ Object = Get-CardanoMintContractDescription -MintContract $MintContract }
        @{ NoNewLine = $false }
    )

    $_policy = @(
        @{ Object = '+--------+' + '-' * 119; ForegroundColor = 'DarkGray' }
        @{ Object = '| POLICY | Description: Rules surrounding mint actions (minting, burning, etc.)'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-MintContractPolicy -MintContract $MintContract | 
                    ConvertTo-Yaml | Format-ColoredYaml | Out-String }
    )

    $_tokenSpecifications = @(
        @{ Object = '+----------------------+' + '-' * 118; ForegroundColor = 'DarkGray' }
        @{ Object = '| TOKEN SPECIFICATIONS | Description: Specifications of tokens within the policy scope'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+----------------------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-MintContractTokenSpecifications -MintContract $MintContract | Format-Table | Out-String }
    )

    $_tokenImplementations = @(
        @{ Object = '+-----------------------+' + '-' * 119; ForegroundColor = 'DarkGray' }
        @{ Object = '| TOKEN IMPLEMENTATIONS | Description: Implementations of token specifications'
           ForegroundColor = 'DarkGray' }
        @{ Object = '+-----------------------+'; ForegroundColor = 'DarkGray' }
        @{ Prefix = @{ Object = '    '; NoNewline = $true }; 
           Object = Get-MintContractTokenImplementationsStatus -MintContract $MintContract | Format-Table | Out-String }
    )

    Write-HostBatch $(
        $_header + 
        $_policy +
        $_tokenSpecifications +
        $_tokenImplementations
    )
}