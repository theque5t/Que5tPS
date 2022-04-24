function Add-CardanoWalletAddress {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [parameter(Mandatory = $true)]
        [string]$Name,
        [parameter(Mandatory = $true)]
        [string]$Description,
        [parameter(Mandatory = $true)]
        [string]$KeyPairName,
        [Parameter(Mandatory=$true, ParameterSetName = 'CreateAddress')]
        [SecureString]$Password,
        [Parameter(Mandatory=$true, ParameterSetName = 'ImportAddress')]
        [string]$Hash,
        [bool]$UpdateState = $true
    )    
    try{
        Assert-CardanoWalletKeyPairNameExists `
            -Wallet $Wallet `
            -Name $KeyPairName
        Assert-CardanoWalletAddressNameIsValid `
            -Wallet $Wallet `
            -Name $Name

        if($PSCmdlet.ParameterSetName -eq 'CreateAddress'){
            $network = Get-CardanoWalletNetwork -Wallet $Wallet
            Assert-CardanoNodeSessionIsOpen -Network $network
            
            $WorkingDir = Get-CardanoWalletWorkingDirectory -Wallet $Wallet
            $addressFile = "$WorkingDir\$($(New-Guid).Guid).addr"
            $verificationKey = Get-CardanoWalletVerificationKey `
                -Wallet $Wallet `
                -KeyPairName $KeyPairName `
                -Decrypt `
                -Password $Password
            $verificationKeyFile = "$WorkingDir\$($(New-Guid).Guid).vkey"
            $verificationKey | Out-File $verificationKeyFile
            $socket = Get-CardanoNodeSocket -Network $network
            $nodePath = Get-CardanoNodePath -Network $network
            $networkArgs = Get-CardanoNodeNetworkArg -Network $network
            $_args = @(
                'address','build'
                '--payment-verification-key-file', $verificationKeyFile
                '--out-file', $addressFile
                $networkArgs
            )
            Invoke-CardanoCLI `
                -Socket $socket `
                -Path $nodePath `
                -Arguments $_args

            $Hash = Get-Content -Path $addressFile -Raw
        }
        $Wallet.Addresses += New-CardanoWalletAddress `
            -Name $Name `
            -Description $Description `
            -Hash $Hash `
            -KeyPairName $KeyPairName
        
        if($UpdateState){
            Update-CardanoWallet -Wallet $Wallet
        }
    }
    catch{
        if($_.Exception.Message -like 'False Assertion*'){ $_ }
        # else{ Write-TerminatingError -Exception "Failed to add address"}
        else {$_}
    }
    finally{
        @($verificationKeyFile, $addressFile).Where({ $_ }).ForEach({ 
            if(Test-Path $_){ Remove-Item $_ } 
        })
    }
}
