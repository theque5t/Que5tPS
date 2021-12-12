function Remove-CardanoWallet {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
        if($PSCmdlet.ShouldProcess($Name)){
            Assert-CardanoWalletSessionIsClosed
            Assert-CardanoWalletExists $Name
            
            Write-VerboseLog "Removing wallet $Name..."
            
            $walletConfig = Get-CardanoWalletConfig $Name
    
            switch ($walletConfig.SigningKeyType) {
                'secret' { 
                    $signingKeySecret = $(
                        Get-SecretInfo -Vault $walletConfig.WalletVault
                    ).Where({
                        $_.Metadata.wallet -eq $Name -and
                        $_.Metadata.keyType -eq 'signing'
                    }) 
                    $signingKeySecret | Remove-Secret
                    
                    Write-VerboseLog (
                        "Removed signing key secret $($signingKeySecret.Name) " +
                        "from wallet vault $($signingKeySecret.VaultName)..."
                    )
                    
                    if($walletConfig.RegisteredVault -eq $true){
                        $walletVault = $Name
                        Write-VerboseLog "Unregistering wallet vault $walletVault..."
                        Unregister-SecretVault -Name $walletVault
                    }
                }
            }
    
            Remove-CardanoWalletFileSet $Name
    
            Assert-CardanoWalletDoesNotExist $Name
            Write-VerboseLog "Wallet $Name removed"
        }
    }
}
