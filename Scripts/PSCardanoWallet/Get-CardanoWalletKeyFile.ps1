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
        $walletKeys = Get-CardanoWalletKeyFiles $Name
        switch ($Type) {
            'signing'      { $extension = 'skey' }
            'verification' { $extension = 'vkey' }
        }
        $walletKeys = $walletKeys.Where({ 
            $_.Name -eq "$Name.$extension"
        })
        return $walletKeys
    }
}
