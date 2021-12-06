function Open-CardanoWalletSession {
    [CmdletBinding()]
    param()
    DynamicParam {
        DynamicParameterDictionary (
            (
                DynamicParameter `
                -Name Name `
                -Attributes @{ Mandatory = $true } `
                -ValidateSet $(Get-CardanoWallets).Name `
                -Type string
            )
        )
    }
    process {
        Assert-CardanoWalletSessionIsClosed
        Assert-CardanoNodeInSync
    
        Write-VerboseLog 'Opening Cardano wallet session...'
        $env:CARDANO_WALLET = $PSBoundParameters.Name
        $env:CARDANO_WALLET_SESSION = $true
    
        Assert-CardanoWalletSessionIsOpen
        Write-VerboseLog 'Cardano wallet session opened'
    }
}
