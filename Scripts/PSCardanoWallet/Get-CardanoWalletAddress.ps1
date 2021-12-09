function Get-CardanoWalletAddress {
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
        Write-VerboseLog "Getting wallet address..."
        $address = $(
            Get-CardanoWalletAddressFile $Name $File |
            Get-Content
        )
        return $address
    }
}
