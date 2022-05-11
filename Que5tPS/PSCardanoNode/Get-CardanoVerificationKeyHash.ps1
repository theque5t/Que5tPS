function Get-CardanoVerificationKeyHash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('mainnet','testnet')]
        $Network,
        [Parameter(Mandatory = $true)]
        $WorkingDir,
        [Parameter(Mandatory = $true)]
        [securestring]$VerificationKey
    )
    try{
        $verificationKeyFile = "$WorkingDir\$($(New-Guid).Guid).vkey"
        $VerificationKey | 
            ConvertFrom-SecureString -AsPlainText | 
            Out-File $verificationKeyFile
        $socket = Get-CardanoNodeSocket -Network $Network
        $nodePath = Get-CardanoNodePath -Network $Network
        $_args = @(
            'address', 'key-hash'
            '--payment-verification-key-file', $verificationKeyFile
        )
        $query = Invoke-CardanoCLI `
            -Socket $socket `
            -Path $nodePath `
            -Arguments $_args
        return $($query | ConvertFrom-Json)
    }
    catch{
        Write-TerminatingError -Exception $_
    }
    finally{
        if(Test-Path $verificationKeyFile){ Remove-Item $verificationKeyFile } 
    }
}
