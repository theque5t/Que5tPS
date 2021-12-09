function New-CardanoWalletKeys {
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
        Write-VerboseLog "Generating wallet keys..."
        $walletPath = $(Get-CardanoWallet $Name).FullName
        $walletKeys = "$walletPath\keys"
        $verificationKey = "$walletKeys\$Name.vkey"
        $signingKey = "$walletKeys\$Name.skey"
        $_args = @(
            'address', 'key-gen'
            '--verification-key-file', $verificationKey
            '--signing-key-file', $signingKey
        )
        Invoke-CardanoCLI @_args
    }
}
