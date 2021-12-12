function Get-CardanoWalletKeyFile {
    [CmdletBinding()]
    param(
        [ValidateSet('signing','verification')]
        $Type
    )
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
        $walletKeys = Get-CardanoWalletKeyFiles $Name
        switch ($Type) {
            'signing'      { $extension = 'skey' }
            'verification' { $extension = 'vkey' }
        }
        $walletKey = $walletKeys.Where({ 
            $_.Name -eq "$Name.$extension"
        })
        return $walletKey
    }
}
