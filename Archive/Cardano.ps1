# function Get-CardanoWalletTransactions {}

# function New-CardanoTransaction {}

# function Set-CardanoTransaction {}

# function Submit-CardanoTransaction {}

# $PSDefaultParameterValues["Test-Params:Test"]={ if(Test-Path env:TEST_VALUE){ $env:TEST_VALUE } }
# function Test-Params {
#     [CmdletBinding()]
#     param()
#     DynamicParam {
#         DynamicParameterDictionary (
#             (
#                 DynamicParameter `
#                 -Name Test `
#                 -Attributes @{ Mandatory = $true } `
#                 -ValidateSet $(Get-ChildItem).Name `
#                 -Type string
#             )
#         )
#     }
#     begin{
#         $Test = $PSBoundParameters.Test
#     }
#     process{
#         Write-Output "$Test"
#     }
# }

# function Test-Params2 {
#     [CmdletBinding()]
#     param(
#         # Test param blah blah
#         [Parameter(Mandatory = $true)]
#         [ArgumentCompleter({ $(Get-CardanoWallets).Name })]
#         [ValidateScript({ $_ -in $(Get-CardanoWallets).Name })]
#         $Name
#     )
#     DynamicParam {
#         DynamicParameterDictionary (
#             (
#                 DynamicParameter `
#                 -Name File `
#                 -Attributes @{ Mandatory = $true } `
#                 -ValidateSet $(Get-CardanoWalletAddressFiles $Name).Name `
#                 -Type string
#             )
#         )
#     }
#     process{
#         Write-Output "$Test"
#     }
# }

# function Get-CardanoWalletAddressFile {
#     [CmdletBinding()]
#     param(
#         # Test param blah blah
#         [Parameter(Mandatory = $true)]
#         [ArgumentCompleter({ $(Get-CardanoWallets).Name })]
#         [ValidateScript({ $_ -in $(Get-CardanoWallets).Name },
#          ErrorMessage = "The wallet, {0}, is not valid per the following script: {1}")]
#         $Name,

#         [Parameter(Mandatory = $true)]
#         [ArgumentCompleter({ 
#             param($Command, $Param, $Input, $AST, $PSPreBoundParameters)
#             $(Get-CardanoWalletAddressFiles $PSPreBoundParameters.Name).Name 
#         })]
#         [ValidateScript({ $_ -in $(Get-CardanoWalletAddressFiles $PSBoundParameters.Name).Name },
#          ErrorMessage = "The wallet address file, {0}, is not valid per the following script: {1}")]
#         $File
#     )
#     process{
#         Write-Output "Name: $Name"
#         Write-Output "File: $File"
#     }
# }

# using namespace System.Management.Automation

# class ValidWalletsGenerator : IValidateSetValuesGenerator {
#     [string[]] GetValidValues() {
#         $Values = (Get-CardanoWallets).Name
#         return $Values
#     }
# }

# class ValidWalletAddressesGenerator : IValidateSetValuesGenerator {
#     [string[]] GetValidValues($Name) {
#         $Values = Get-CardanoWalletAddressFiles $Name
#         return $Values
#     }
# }

# function Test-Params3 {
#     [CmdletBinding()]
#     param(
#         [Parameter(Position = 0, Mandatory)]
#         [ValidateSet( [ValidWalletsGenerator] )]
#         [string]
#         $Name,
#         [Parameter(Position = 1, Mandatory)]
#         [ValidateSet( [ValidWalletAddressesGenerator] )]
#         [string]
#         $File
#     )

#     process{
#         Write-Output "Name: $Name"
#         Write-Output "File: $File"
#     }
# }

# function Test-Process{
#     $Recipients = [ordered]@{"1" = "addr1"; "2" = "addr2"; "3" = "addr3"}
#     $Tokens = [ordered]@{ "1" = @{ Token = "lovelace"; Quantity = 10000000 }; "2" = @{ Token = "factory"; Quantity = 1 } }

#     do{
#         $allocationsComplete = $false
#         Write-Host "Current allocated tokens:"
#         Write-Host "<allocated tokens table with recipient column>"
#         Write-Host "Current transaction fee: <fee>"
#         Write-Host "Current unallocated tokens:"
#         Write-Host "<unallocated tokens table>"
#         Write-Host "NOTE: Any unallocated tokens will be automatically allocated as change for a recipient that will need to be specified"
#         Write-Host "Select an allocation action, or specify finished allocating"
#         Write-Host "1 - Allocate token"
#         Write-Host "2 - Deallocate token"
#         Write-Host "3 - Finished allocating"
#         Write-Host "Input: " -NoNewline
#         $selection = Read-Host 
#         switch($selection){
#             1 { Write-Host "Select a recipient:"
#                 $Recipients.GetEnumerator().ForEach({
#                     Write-Host "$($_.Key)) $($_.Value)"
#                 })
#                 Write-Host "Input: " -NoNewline
#                 $recipient = Read-Host
                
#                 Write-Host "Select a token:"
#                 $Tokens.GetEnumerator().ForEach({
#                     Write-Host "$($_.Key))"
#                     $_.Value | Select-Object * | Format-Table | Out-String | Write-Host
#                 })
#                 Write-Host "Input: " -NoNewline
#                 $token = Read-Host

#                 Write-Host "Select a quantity to allocate:"
#                 Write-Host "Input: " -NoNewline
#                 $quantity = Read-Host

#                 Write-Output "Allocated $quantity of $($Tokens[$token].Token) to $($Recipients[$recipient])"
#                 Write-Output "$($Tokens[$token].Quantity - $quantity) $($Tokens[$token].Token) left..."
#             }
#             2 { Write-Output "deallocating token..." }
#             3 { Write-Output "Finish..."; $allocationsComplete = $true }
#             default { Write-Host "Invalid Selection: $_" -ForegroundColor Red }
#         }
#     }
#     until($allocationsComplete)
# }

# function Get-AvailableTokens($Utxos) {
#     $availableTokens = @{}
#     $Utxos.Utxos.ForEach({ 
#         $_.Value.ForEach({ 
#             $availableTokens["$($_.PolicyId).$($_.Name)"] = [CardanoToken]::new($_.PolicyId, $_.Name, 0) 
#         }) 
#     })
#     $availableTokens.GetEnumerator().ForEach({ 
#         $token = $_.Value
#         $token.Quantity = $(
#             $Utxos.Utxos.Value.Where({ 
#                 $_.PolicyId -eq $token.PolicyId -and 
#                 $_.Name -eq $token.Name 
#             }).Quantity | Measure-Object -Sum
#         ).Sum
#     })
#     $availableTokens = $availableTokens.GetEnumerator().ForEach({ $_.Value })
#     return $availableTokens
# }

# function Get-UnallocatedTokens ($Utxos, $Allocations) {
#     $allAvailableTokens = Get-AvailableTokens $Utxos
#     $allocatedTokens = $Allocations.GetEnumerator().ForEach({ $_.Value })
#     $unallocatedTokens = $allAvailableTokens.ForEach({
#         $availableToken = $_
#         $allocatedQuantity = $(
#             $allocatedTokens.Where({ 
#                 $_.PolicyId -eq $availableToken.PolicyId -and
#                 $_.Name -eq $availableToken.Name
#             }).Quantity | Measure-Object -Sum
#         ).Sum
#         $availableToken.Quantity = $availableToken.Quantity - $allocatedQuantity
#         if($availableToken.Quantity){
#             $availableToken
#         }
#     })
#     return $unallocatedTokens
# }

$tx4 = [CardanoTransaction]::new('C:\Users\ananonone\OneDrive\Documents\Dev\Que5tPS\','tx4')
$Utxo1 = [CardanoUtxo]::new('eb2bd1#0', 'addr_test1blah', '')
$Utxo1.AddToken('', 'lovelace', 50)

$Utxo2 = [CardanoUtxo]::new('d1cf3b#0', 'addr_test2blah', '')
$Utxo2.AddToken('', 'lovelace', 25)
$Utxo2.AddToken('ad234as', 'blah', 3)

$Utxo3 = [CardanoUtxo]::new('c483cb#0', 'addr_test2blah', 'bc7473')
$Utxo3.AddToken('', 'lovelace', 25)
$Utxo3.AddToken('4fc16c9', 'blah', 1)

$Utxo4 = [CardanoUtxo]::new('c483cb#1', 'addr_test2blah', 'bc7473')
$Utxo4.AddToken('ad234as', 'blah', 1)

$Utxo5 = [CardanoUtxo]::new('c483cb#2', 'addr_test2blah', 'bc7473')
$Utxo5.AddToken('fda231d', 'warrior1', 1)
$Utxo5.AddToken('ad234as', 'punks', 2)

$tx4.AddInput($Utxo1)
$tx4.AddInput($Utxo2)
$tx4.AddInput($Utxo3)
$tx4.AddInput($Utxo4)
$tx4.AddInput($Utxo5)

$tx4.SetChangeAddress('addr_test1blah')
$tx4.GetChangeAllocation()

$tx4.AddOutput([CardanoTransactionOutput]::new('addr_test3blah', @([CardanoToken]::new('ad234as', 'blah', 1))))

# $Utxos = New-Object CardanoUtxoList
# $Utxos.AddUtxo($Utxo1)
# $Utxos.AddUtxo($Utxo2)
# $Utxos.AddUtxo($Utxo3)

# # TEST: NO ALLOCATIONS 
# $Recipients = @('addr_test3','addr_test4')
# $Allocations = [ordered]@{}
# $($Recipients).ForEach({
#     $recipient = $_
#     $Allocations.$recipient = [System.Collections.ArrayList]@()
#     $(Get-AvailableTokens($Utxos)).ForEach({
#         $token = $_
#         $Allocations.$recipient.Add([CardanoToken]::new($token.PolicyId,$token.Name,0)) | Out-Null
#     })
# })

# $Allocations.GetEnumerator().ForEach({
#     [CardanoTransactionOutput[]]$transactionOutputs += [CardanoTransactionOutput]::new($_.Key, $_.Value)
# })
# $transaction = [CardanoTransaction]::new(
#     'C:\Users\ananonone\OneDrive\Documents\Dev\Que5tPS\test.tx', $Utxos, $transactionOutputs
# )

# # TEST: WITH ALLOCATIONS 
# $Allocations = @{
#     "addr_test3" = [CardanoToken]::new('','lovelace',5), [CardanoToken]::new('4fc16c9','factory',1)
#     "addr_test4" = [CardanoToken]::new('','lovelace',5)
# }

# # $Allocations.GetEnumerator().ForEach({
#     $transactionOutputs += [CardanoTransactionOutput]::new($_.Key, $_.Value)
# })
# $transaction = [CardanoTransaction]::new(
#     'C:\Users\ananonone\OneDrive\Documents\Dev\Que5tPS\test.tx', $Utxos, $transactionOutputs
# )

# function Write-HostBatch {
#     [CmdletBinding()]
#     param(
#         [parameter(Mandatory=$true,Position=0)]
#         $Batch
#     )
#     Write-Verbose "`$Batch.Count: $($Batch.Count)"
#     $Batch.ForEach({ 
#         $_args = $_
#         Write-Verbose "`$_args.Keys: $($_args.Keys)"
#         Write-Verbose "`$_args.Values: $($_args.Values)"
#         Write-Host @_
#     })
# }


# function TestGet-OptionSelection {
#     [CmdletBinding()]
#     param(
#         [array]$Options,
#         $Instruction,
#         $OptionDisplayTemplate = @(
#             @{ Expression = '$($option.Key)'; ForegroundColor = 'Cyan'; NoNewline = $true},
#             @{ Expression = ') $($option.Value)' }
#         )
#     )
    
#     $optionsAvailable = [ordered]@{}
#     $Options.ForEach({
#         $key = "$($optionsAvailable.Count + 1)"
#         Write-Verbose "`$optionsAvailable.Add($key, $_)"
#         $optionsAvailable.Add($key, $_)
#     })

#     $selectionOutput = New-Object System.Collections.ArrayList
#     $selectionOutput.Add(@{ Object = $Instruction; ForegroundColor = 'Yellow' }) | Out-Null
#     Write-Verbose "`$selectionOutput.Count: $($selectionOutput.Count)"
#     $optionsAvailable.GetEnumerator().ForEach({
#         $option = $_
#         Write-Verbose "`$option.Key: $($option.Key)"
#         Write-Verbose "`$option.Value: $($option.Value)"
#         Write-Verbose "`$OptionDisplayTemplate.Count: $($OptionDisplayTemplate.Count)"
#         $OptionDisplayTemplate.ForEach({
#             $template = $_
#             Write-Verbose "`$template.Keys: $($template.Keys)"
#             Write-Verbose "`$template.Values: $($template.Values)"
#             $renderedTemplate = $template.Clone()
#             Write-Verbose "`$renderedTemplate.Keys: $($renderedTemplate.Keys)"
#             Write-Verbose "`$renderedTemplate.Values: $($renderedTemplate.Values)"
#             if($renderedTemplate.ContainsKey('Expression')){
#                 Write-Verbose "`$renderedTemplate.ContainsKey('Expression'): true"
#                 $expandedExpression = $ExecutionContext.InvokeCommand.ExpandString($renderedTemplate.Expression)
#                 Write-Verbose "`$expandedExpression: $expandedExpression"
#                 $renderedTemplate.Add('Object', $expandedExpression)
#                 $renderedTemplate.Remove('Expression')
#             }
#             Write-Verbose "`$renderedTemplate.Keys: $($renderedTemplate.Keys)"
#             Write-Verbose "`$renderedTemplate.Values: $($renderedTemplate.Values)"
#             $selectionOutput.Add($renderedTemplate) | Out-Null
#         })
#     })
#     Write-Verbose "`$selectionOutput.Count: $($selectionOutput.Count)"
#     Write-HostBatch $selectionOutput

#     $validOptionSelection = $false
#     do{
#         Write-Host "Input: " -NoNewline
#         $optionSelection = Read-Host
#         $optionSelection = $optionSelection.Trim()
#         switch($optionSelection) {
#             {$optionsAvailable.Contains($optionSelection)} {
#                 $validOptionSelection = $true
#                 $optionSelection = $optionsAvailable[$optionSelection]
#             }
#             default { Write-Host "Invalid Selection: $_" -ForegroundColor Red }
#         }
#     }
#     while(-not $validOptionSelection)
#     return $optionSelection
# }