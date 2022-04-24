function Import-CardanoWalletState {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet
    )
    Assert-CardanoWalletStateFileExists -Wallet $Wallet
    $Wallet.StateFile = Get-Item $Wallet.StateFile
    $Wallet.StateFileContent = Get-Content $Wallet.StateFile
    if($Wallet.StateFileContent){
        $state = Get-Content $Wallet.StateFile | ConvertFrom-Yaml
        $state.KeyPairs = [array]$state.KeyPairs
        $state.Addresses = [array]$state.Addresses

        Set-CardanoWalletName `
            -Wallet $Wallet `
            -Name $state.Name `
            -UpdateState $False
        
        Set-CardanoWalletDescription `
            -Wallet $Wallet `
            -Description $state.Description `
            -UpdateState $False

        Set-CardanoWalletNetwork `
            -Wallet $Wallet `
            -Network $state.Network `
            -UpdateState $False
        
        $Wallet.KeyPairs = [CardanoWalletKeyPair[]]@()
        $state.KeyPairs.ForEach({
            Add-CardanoWalletKeyPair `
                -Wallet $Wallet `
                -Name $_.Name `
                -Description $_.Description `
                -VerificationKey $_.VerificationKey `
                -SigningKey $_.SigningKey `
                -UpdateState $False
        })

        $Wallet.Addresses = [string[]]@()
        $state.Addresses.ForEach({
            Add-CardanoWalletAddress `
                -Wallet $Wallet `
                -Name $_.Name `
                -Description $_.Description `
                -Hash $_.Hash `
                -KeyPairName $_.KeyPairName `
                -UpdateState $False
        })
    }
}
