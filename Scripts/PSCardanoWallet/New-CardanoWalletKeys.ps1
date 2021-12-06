function New-CardanoWalletKeys {
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
