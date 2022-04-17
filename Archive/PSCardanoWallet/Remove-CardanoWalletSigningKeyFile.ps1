function Remove-CardanoWalletSigningKeyFile {
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
        if($(Test-CardanoWalletSigningKeyFileExists $Name)){
            Get-CardanoWalletKeyFile $Name -Type signing |
            Remove-Item
        }
        Assert-CardanoWalletSigningKeyFileDoesNotExist $Name
    }
}
