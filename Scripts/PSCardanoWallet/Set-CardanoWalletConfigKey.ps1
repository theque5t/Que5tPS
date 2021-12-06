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
                -Attributes @{ Position = 0 } `
                -ValidateSet $(Get-CardanoWallets).Name `
                -Type string
            )
        )
    }
    begin {
        if (-not $PSBoundParameters.ContainsKey('Name')){
            $PSBoundParameters.Add('Name', $env:CARDANO_WALLET)
        }
        $Name = $PSBoundParameters.Name
    }
    process{
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletConfig = "$walletPath\.config"
        Write-VerboseLog `
            "Setting config key $Key value $Value to $Name wallet..."
        Set-Content "$walletConfig\$Key" -Value "$Value" | Out-Null
    }
}
