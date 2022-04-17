function Get-CardanoWalletKeyFiles {
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
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletKeys = Get-ChildItem $walletPath\keys
        return $walletKeys
    }
}
