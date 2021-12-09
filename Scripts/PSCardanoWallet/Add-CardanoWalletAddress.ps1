function Add-CardanoWalletAddress {
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
            )
        )
    }
    begin {
        $Name = $PSBoundParameters.Name
    }
    process{
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog "Generating wallet address..."
    
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletAddresses = "$walletPath\addresses"
        $walletConfig = Get-CardanoWalletConfig $Name
        $walletAddress = (
            "$walletAddresses\" +
            "$env:CARDANO_NODE_NETWORK$($walletConfig.nextAddressIndex).addr"
        )
        $walletVerificationKey = Get-CardanoWalletKeyFile $Name -Type verification
        $_args = @(
            'address','build'
            '--payment-verification-key-file', $walletVerificationKey
            '--out-file', $walletAddress
            $env:CARDANO_CLI_NETWORK_ARG
            $env:CARDANO_CLI_NETWORK_ARG_VALUE
        )
        Invoke-CardanoCLI @_args
    
        Set-CardanoWalletConfigKey $Name `
            -Key nextAddressIndex `
            -Value $([int]$($walletConfig.nextAddressIndex)+1)
    }
}
