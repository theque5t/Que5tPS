function Get-CardanoWallet {
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
        Write-VerboseLog "Getting wallet..."
        $wallet = $(Get-CardanoWallets).Where({ 
            $_.Name -eq $Name
        })
        return $wallet
    }
}
