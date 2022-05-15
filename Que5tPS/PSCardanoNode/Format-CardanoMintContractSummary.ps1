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

   $_hasPolicyId = Test-CardanoMintContractHasPolicyId -MintContract $MintContract
   $_policy = @(
      @{ Object = '+--------+' + '-' * 119; ForegroundColor = 'DarkGray' }
      @{ Object = '| POLICY | Description: Rules surrounding mint actions (minting, burning, etc.)'
         ForegroundColor = 'DarkGray' }
      @{ Object = '+--------+'; ForegroundColor = 'DarkGray' }
      @{ Object = '' }
   )
   if($_hasPolicyId){
      $_policy += @{ 
         Prefix = @{ Object = '    '; NoNewline = $true }; 
         Object = Get-MintContractPolicy -MintContract $MintContract | ConvertTo-Yaml
      }
   }
   else{
      $_policy += @{ 
         Prefix = @{ Object = '    '; NoNewline = $true }
         Object = 'None - Witness(es) not specified' 
      }
   }
   $_policy += @{ NoNewLine = $_hasPolicyId }

   $_hasTokenSpecifications = Test-CardanoMintContractHasTokenSpecifications -MintContract $MintContract
   $_tokenSpecifications = @(
      @{ Object = '+----------------------+' + '-' * 105; ForegroundColor = 'DarkGray' }
      @{ Object = '| TOKEN SPECIFICATIONS | Description: Specifications of tokens within the policy scope'
         ForegroundColor = 'DarkGray' }
      @{ Object = '+----------------------+'; ForegroundColor = 'DarkGray' }
      @{ Object = '' }
   )
   if($_hasTokenSpecifications){
      $_tokenSpecifications += @{ 
         Prefix = @{ Object = '    '; NoNewline = $true }; 
         Object = Get-MintContractTokenSpecifications -MintContract $MintContract | Format-Table | Out-String
      }
   }
   else{
      $_tokenSpecifications += @{ 
         Prefix = @{ Object = '    '; NoNewline = $true }
         Object = 'None - Token specifications not specified' 
      }
   }
   $_tokenSpecifications += @{ NoNewLine = $_hasTokenSpecifications }

   $_hasTokenImplementations = Test-CardanoMintContractHasTokenImplementations -MintContract $MintContract
   $_tokenImplementations = @(
      @{ Object = '+-----------------------+' + '-' * 104; ForegroundColor = 'DarkGray' }
      @{ Object = '| TOKEN IMPLEMENTATIONS | Description: Implementations of token specifications'
         ForegroundColor = 'DarkGray' }
      @{ Object = '+-----------------------+'; ForegroundColor = 'DarkGray' }
      @{ Object = '' }
   )
   if($_hasTokenImplementations){
      $_tokenImplementations += @{ 
         Prefix = @{ Object = '    '; NoNewline = $true }; 
         Object = Get-MintContractTokenImplementationsStatus -MintContract $MintContract | Format-Table | Out-String
      }
   }
   else{
      $_tokenImplementations += @{ 
         Prefix = @{ Object = '    '; NoNewline = $true }
         Object = 'None - Token implementations not specified' 
      }
   }
   $_tokenImplementations += @{ NoNewLine = $_hasTokenImplementations }

   Write-HostBatch $(
      $_header + 
      $_policy +
      $_tokenSpecifications +
      $_tokenImplementations
   )
}
