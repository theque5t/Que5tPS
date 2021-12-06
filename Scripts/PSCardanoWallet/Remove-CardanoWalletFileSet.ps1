function Remove-CardanoWalletFileSet {
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
        Assert-CardanoWalletExists $Name
        Write-VerboseLog "Removing wallet file set..."
        Get-CardanoWallet $Name | Remove-Item -Recurse
        Assert-CardanoWalletDoesNotExist $Name
    }
}
