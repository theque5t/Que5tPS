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
