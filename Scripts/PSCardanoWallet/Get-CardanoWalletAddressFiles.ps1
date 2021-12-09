function Get-CardanoWalletAddressFiles {
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
        Write-VerboseLog "Getting wallet address file..."
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletAddresses = Get-ChildItem $walletPath\addresses
        return $walletAddresses
    }
}
