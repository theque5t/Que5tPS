function Get-CardanoWalletAddressFile {
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
        Assert-CardanoWalletExists $Name
        $walletAddress = $(Get-CardanoWalletAddressFiles $Name).Where({ 
            $_.Name -eq $File
        })
        return $walletAddress
    }
}
