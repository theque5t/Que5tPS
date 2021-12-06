function Get-CardanoWalletAddressFile {
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
        $walletAddresses = $(Get-CardanoWalletAddressFiles).Where({ 
            $_.Name -eq $File
        })
        return $walletAddresses
    }
}
