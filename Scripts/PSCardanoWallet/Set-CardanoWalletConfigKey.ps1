function Set-CardanoWalletConfigKey {
    [CmdletBinding()]
    param(
        $Key,
        $Value
    )
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
        Assert-CardanoWalletExists $Name
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletConfig = "$walletPath\.config"
        Write-VerboseLog `
            "Setting config key $Key value $Value to $Name wallet..."
        Set-Content "$walletConfig\$Key" -Value "$Value" | Out-Null
    }
}
