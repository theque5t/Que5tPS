function Get-CardanoWalletConfig {
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
        Assert-CardanoWalletExists $Name
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
