function Open-CardanoWalletSession {
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
        Assert-CardanoWalletSessionIsClosed
        Assert-CardanoNodeInSync
    
        Write-VerboseLog 'Opening Cardano wallet session...'
        $env:CARDANO_WALLET = $PSBoundParameters.Name
        $env:CARDANO_WALLET_SESSION = $true
    
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog 'Cardano wallet session opened'
    }
}
