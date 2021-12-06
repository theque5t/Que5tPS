function Get-CardanoWalletAddressUtxo {
    [CmdletBinding()]
    param()
    DynamicParam {
        DynamicParameterDictionary (
            (
                DynamicParameter `
                -Name File `
                -Attributes @{ 
                    Mandatory = $true
                    Position = 0
                } `
                -ValidateSet $(Get-CardanoWalletAddressFiles).Name `
                -Type string
            )
        )
    }
    begin{
        $File = $PSBoundParameters.File
    }
    process{
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog "Getting wallet address utxo..."

        $_args = @(
            'query','utxo'
            '--address', $(Get-CardanoWalletAddress $File)
            $env:CARDANO_CLI_NETWORK_ARG
            $env:CARDANO_CLI_NETWORK_ARG_VALUE
        )
        $query = Invoke-CardanoCLI @_args

        return $query
    }
}
