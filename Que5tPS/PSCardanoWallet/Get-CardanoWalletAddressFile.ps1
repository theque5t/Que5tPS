function Get-CardanoWalletAddressFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ArgumentCompleter({ $(Get-CardanoWallets).Name })]
        [ValidateScript({ $_ -in $(Get-CardanoWallets).Name },
         ErrorMessage = (
         "The wallet, {0}, " + 
         "is not valid per the following script: {1}"))]
        $Name,

        [Parameter(Mandatory = $true, Position = 1)]
        [ArgumentCompleter({ 
            param($Command, $Param, $Input, $AST, $ParamState)
            $(Get-CardanoWalletAddressFiles $ParamState.Name).Name 
        })]
        [ValidateScript({ 
            $_ -in $(Get-CardanoWalletAddressFiles $PSBoundParameters.Name).Name 
        },
         ErrorMessage = (
         "The wallet address file, {0}, " +
         "is not valid per the following script: {1}"))]
        $File
    )
    process{
        Assert-CardanoWalletExists $Name
        $walletAddress = $(Get-CardanoWalletAddressFiles $Name).Where({ 
            $_.Name -eq $File
        })
        return $walletAddress
    }
}
