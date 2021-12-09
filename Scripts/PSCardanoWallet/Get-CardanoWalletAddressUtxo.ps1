function Get-CardanoWalletAddressUtxo {
    [CmdletBinding()]
    param()
    DynamicParam {
        DynamicParameterDictionary (
            (
                DynamicParameter `
                -Name Name `
                -Attributes @{ 
                    Mandatory = $true
                    Position = 0 
                } `
                -ValidateSet $(Get-CardanoWallets).Name `
                -Type string
            ),
            (
                DynamicParameter `
                -Name File `
                -Attributes @{ 
                    Mandatory = $true
                    Position = 1
                } `
                -ValidateSet $(
                    Get-CardanoWalletAddressFiles $PSBoundParameters.Name
                ).Name `
                -Type string
            )
        )
    }
    begin {
        $Name = $PSBoundParameters.Name
        $File = $PSBoundParameters.File
    }
    process{
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog "Getting wallet address utxo..."

        $_args = @(
            'query','utxo'
            '--address', $(Get-CardanoWalletAddress $Name $File)
            $env:CARDANO_CLI_NETWORK_ARG
            $env:CARDANO_CLI_NETWORK_ARG_VALUE
        )
        $query = Invoke-CardanoCLI @_args

        return $query
    }
}
