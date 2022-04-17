function Get-CardanoWalletAddressUtxos {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ArgumentCompleter({ 
            param($Command, $Param, $Input, $AST, $ParamState)
            $(Get-CardanoWallets).Name 
        })]
        [ValidateScript({ $_ -in $(Get-CardanoWallets).Name },
         ErrorMessage = (
         "The wallet, {0}, " + 
         "is not valid per the following script: {1}"))]
        $Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [ArgumentCompleter({ 
            param($Command, $Param, $Input, $AST, $ParamState)
            $Name = Get-BoundValueElseDefaultValue `
                        Name `
                        $ParamState `
                        $Command
            $(Get-CardanoWalletAddressFiles $Name).Name 
        })]
        [ValidateScript({ 
            $Name = Get-BoundValueElseDefaultValue `
                        Name `
                        $PSBoundParameters `
                        $PSCmdlet.MyInvocation.MyCommand
            $_ -in $(Get-CardanoWalletAddressFiles $Name).Name 
        },
         ErrorMessage = (
         "The wallet address file, {0}, " +
         "is not valid per the following script: {1}"))]
        $File
    )
    process{
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog "Getting wallet address utxo..."

        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletTemp = "$walletPath\.temp"

        $utxos = Get-CardanoAddressUtxos `
                    -Address $(Get-CardanoWalletAddress $Name $File)`
                    -WorkingDir $walletTemp
        return $utxos
    }
}
