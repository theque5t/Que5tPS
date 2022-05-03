function Get-CardanoWalletSigningKey {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [CardanoWallet]$Wallet,
        [Parameter(Mandatory=$true)]
        [string]$KeyPairName,
        [Parameter(Mandatory=$true, ParameterSetName = 'Decrypt')]
        [switch]$Decrypt,
        [Parameter(ParameterSetName = 'Decrypt')]
        [AllowNull()]
        [securestring]$Password
    )
    $keyPair = Get-CardanoWalletKeyPair -Wallet $Wallet -Name $KeyPairName
    $signingKey = $keyPair.SigningKey
    if($Decrypt){
        if(-not $Password){
            $Password = Get-PasswordInput `
                -Instruction "Specify the password for key pair `"$KeyPairName`":"
        }
        $signingKey = Unprotect-String `
            -String $signingKey `
            -Password $Password
    }
    return $signingKey
}
