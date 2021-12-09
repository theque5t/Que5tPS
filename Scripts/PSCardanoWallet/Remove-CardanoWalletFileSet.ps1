function Remove-CardanoWalletFileSet {
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
        Write-VerboseLog "Removing wallet file set..."
        Get-CardanoWallet $Name | Remove-Item -Recurse
        Assert-CardanoWalletDoesNotExist $Name
    }
}
