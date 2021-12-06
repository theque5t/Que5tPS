function Get-CardanoWalletConfig {
    [CmdletBinding()]
    param()
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
        $walletConfigHashtable = @{}
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletConfig = "$walletPath\.config"
        $(Get-ChildItem $walletConfig).ForEach({
            $key = $_
            $value = Get-Content $key
            $walletConfigHashtable[$key.Name] = $value
        })
        return $walletConfigHashtable
    }
}
