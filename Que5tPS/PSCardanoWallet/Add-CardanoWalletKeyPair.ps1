function Add-CardanoWalletKeyPair {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [Parameter(Mandatory=$true, ParameterSetName = 'CreateKeyPair')]
        [SecureString]$Password,
        [Parameter(Mandatory=$true, ParameterSetName = 'ImportKeyPair')]
        [string]$VerificationKey,
        [Parameter(Mandatory=$true, ParameterSetName = 'ImportKeyPair')]
        [string]$SigningKey,
        [bool]$UpdateState = $true
    )
    try{
        Assert-CardanoWalletKeyPairNameIsValid `
            -Wallet $Wallet `
            -Name $Name
        
        if($PSCmdlet.ParameterSetName -eq 'CreateKeyPair'){
            $network = Get-CardanoWalletNetwork -Wallet $Wallet
            Assert-CardanoNodeSessionIsOpen -Network $Network

            $WalletDir = Get-CardanoWalletDirectory -Wallet $Wallet
            $verificationKeyFile = "$WalletDir\$($(New-Guid).Guid).vkey"
            $signingKeyFile = "$WalletDir\$($(New-Guid).Guid).skey"
            $socket = Get-CardanoNodeSocket -Network $Network
            $nodePath = Get-CardanoNodePath -Network $Network
            $_args = @(
                'address', 'key-gen'
                '--verification-key-file', $verificationKeyFile
                '--signing-key-file', $signingKeyFile
            )
            Invoke-CardanoCLI `
                -Socket $socket `
                -Path $nodePath `
                -Arguments $_args

            $VerificationKey = Protect-String `
                -String $(Get-Content -Path $verificationKeyFile -Raw) `
                -Password $Password
            $SigningKey = Protect-String `
                -String $(Get-Content -Path $signingKeyFile -Raw) `
                -Password $Password
        }
        $Wallet.KeyPairs += New-CardanoWalletKeyPair `
            -Name $Name `
            -Description $Description `
            -VerificationKey $VerificationKey `
            -SigningKey $SigningKey
        
        if($UpdateState){
            Update-CardanoWallet -Wallet $Wallet
        }
    }
    catch{
        if($_.Exception.Message -like 'False Assertion*'){ $_ }
        else{ Write-TerminatingError -Exception "Failed to add key pair"}
    }
    finally{
        @($verificationKeyFile, $signingKeyFile).Where({ $_ }).ForEach({ 
            if(Test-Path $_){ Remove-Item $_ } 
        })
    }
}