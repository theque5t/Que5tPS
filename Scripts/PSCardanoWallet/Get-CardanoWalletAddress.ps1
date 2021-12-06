function Get-CardanoWalletAddress {
    [CmdletBinding()]
    param()
    DynamicParam {
        DynamicParameterDictionary (
            (
                DynamicParameter `
                -Name File `
                -Attributes @{ 
                    Mandatory = $true
                    Position = 0
                } `
                -ValidateSet $(Get-CardanoWalletAddressFiles).Name `
                -Type string
            )
        )
    }
    begin{
        $File = $PSBoundParameters.File
    }
    process{
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog "Getting wallet address..."
        $address = $(
            Get-CardanoWalletAddressFile $File |
            Get-Content
        )
        return $address
    }
}
