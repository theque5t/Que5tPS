function Add-CardanoWallet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet('plaintext','secret')]
        $SigningKeyType
    )
    DynamicParam {        
        switch ($SigningKeyType) {
            'secret' { 
                DynamicParameterDictionary (
                    (
                        DynamicParameter `
                        -Name RegisterVault `
                        -Attributes @{ 
                            Mandatory = $true
                            ParameterSetName = 'RegisterVault' } `
                        -Type switch
                    ),
                    (
                        DynamicParameter `
                        -Name UseVault `
                        -Attributes @{ 
                            Mandatory = $true
                            ParameterSetName = 'UseVault' } `
                        -Type string
                    )
                )
            }
        }
    }
    process {
        Assert-CardanoNodeInSync
        Assert-CardanoWalletDoesNotExist $Name
        
        Write-VerboseLog "Adding wallet $Name..."
        
        Add-CardanoWalletFileSet $Name
        New-CardanoWalletKeys $Name

        switch ($SigningKeyType) {
            'secret' {
                Set-CardanoWalletConfigKey `
                    -Name $Name `
                    -Key SigningKeyType `
                    -Value $_
                $walletVault = $Name
                switch ($PsCmdlet.ParameterSetName) {
                    'RegisterVault' { 
                        Write-VerboseLog `
                            "Registering wallet vault $walletVault..."
                        Set-CardanoWalletConfigKey `
                            -Name $Name `
                            -Key RegisteredVault `
                            -Value $true
                        Register-SecretVault `
                            -Name $walletVault `
                            -ModuleName Microsoft.PowerShell.SecretStore `
                            -DefaultVault:$false
                    }
                    'UseVault' {
                        Set-CardanoWalletConfigKey `
                            -Name $Name `
                            -Key RegisteredVault `
                            -Value $false
                        $walletVault = $PSBoundParameters.UseVault
                    }
                }
                
                Set-CardanoWalletConfigKey `
                    -Name $Name `
                    -Key WalletVault `
                    -Value $walletVault
                
                $secretName = New-Guid
                $secretValue = $(
                    Get-CardanoWalletKeyFile $Name -Type signing | 
                    Get-Content | 
                    ConvertFrom-Json -AsHashtable
                )
                Set-Secret `
                    -Name $secretName `
                    -Secret $secretValue `
                    -Vault $walletVault `
                    -Metadata @{ 
                        createdBy = 'PSCardano'
                        wallet = $Name 
                        keyType = 'signing'
                    } `
                    -NoClobber
                Remove-CardanoWalletSigningKeyFile $Name
                Assert-CardanoWalletSigningKeyFileDoesNotExist $Name
                Write-VerboseLog (
                    "Saved signing key as secret $secretName " +
                    "to wallet vault $walletVault..."
                )
            }
            'plaintext' {
                Set-CardanoWalletConfigKey -Name $Name -Key SigningKeyType -Value $_
                Write-VerboseLog `
                    "Saved signing key as plain text in file $signingKey..."
            }
        }

        Set-CardanoWalletConfigKey $Name -Key nextAddressIndex -Value 0

        Assert-CardanoWalletExists $Name
        Write-VerboseLog "Wallet $Name added"
    }
}
